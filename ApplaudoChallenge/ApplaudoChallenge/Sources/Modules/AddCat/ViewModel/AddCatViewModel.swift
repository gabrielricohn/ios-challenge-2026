//
//  AddCatViewModel.swift
//  ApplaudoChallenge
//
//  Created by Gabriel Rico on 25/6/26.
//

import Combine
import Foundation
import NetworkLayer

@MainActor
final class AddCatViewModel: ObservableObject {

    // MARK: - Step Definition

    enum Step: Int, CaseIterable {
        case name
        case breed
        case age
        case description

        var title: String {
            switch self {
            case .name: return "Name"
            case .breed: return "Breed"
            case .age: return "Age"
            case .description: return "Description"
            }
        }

        var headerTitle: String {
            switch self {
            case .name: return "Cat Name"
            case .breed: return "Select Breed"
            case .age: return "Cat Age"
            case .description: return "Short Description"
            }
        }

        var headerSubtitle: String {
            switch self {
            case .name: return "What is your cat called?"
            case .breed: return "Choose a breed from the catalog"
            case .age: return "How old is your cat in years?"
            case .description: return "Tell us a little about your cat"
            }
        }

        var systemImage: String {
            switch self {
            case .name: return "pencil"
            case .breed: return "cat"
            case .age: return "calendar"
            case .description: return "text.alignleft"
            }
        }
    }

    // MARK: - Published State

    @Published var currentStep: Step = .name
    @Published var name = ""
    @Published var breed = ""
    @Published var age = ""
    @Published var description = ""
    @Published var breeds: [CatBreed] = []
    @Published var isLoadingBreeds = false
    @Published var breedsErrorMessage: String?
    @Published var showSaveConfirmation = false
    @Published var saveErrorMessage: String?
    @Published var savedCats: [RegisteredCat] = []
    @Published var isShowingForm = false
    @Published var showValidationErrors = false

    // MARK: - Validation

    private enum Validation {
        static let minimumNameLength = 2

        static func nameError(for value: String) -> String? {
            let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty { return "Name is required." }
            if trimmed.count < minimumNameLength {
                return "Name must be at least \(minimumNameLength) characters."
            }
            return nil
        }

        static func breedError(for value: String) -> String? {
            if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return "Breed is required."
            }
            return nil
        }

        static func ageError(for value: String) -> String? {
            let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty { return "Age is required." }
            guard let ageValue = Int(trimmed) else { return "Age must be a valid number." }
            if ageValue <= 0 { return "Age must be a positive number." }
            return nil
        }

        static func descriptionError(for value: String) -> String? {
            if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return "Description is required."
            }
            return nil
        }
    }

    // MARK: - Computed Properties

    var shouldShowEmptyState: Bool {
        savedCats.isEmpty && !isShowingForm
    }

    var stepTitles: [String] {
        Step.allCases.map(\.title)
    }

    var currentStepIndex: Int {
        currentStep.rawValue
    }

    var totalSteps: Int {
        Step.allCases.count
    }

    var canGoBack: Bool {
        currentStep != .name
    }

    var isLastStep: Bool {
        currentStep == .description
    }

    var primaryButtonTitle: String {
        isLastStep ? "Save Cat" : "Continue"
    }

    var canProceed: Bool {
        validationError(for: currentStep) == nil
    }

    var nameValidationError: String? {
        guard showValidationErrors, currentStep == .name else { return nil }
        return Validation.nameError(for: name)
    }

    var breedValidationError: String? {
        guard showValidationErrors, currentStep == .breed else { return nil }
        return Validation.breedError(for: breed)
    }

    var ageValidationError: String? {
        guard showValidationErrors, currentStep == .age else { return nil }
        return Validation.ageError(for: age)
    }

    var descriptionValidationError: String? {
        guard showValidationErrors, currentStep == .description else { return nil }
        return Validation.descriptionError(for: description)
    }

    var filteredBreeds: [CatBreed] {
        let query = breed.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return breeds }

        return breeds.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

    // MARK: - Dependencies

    private let catService: CatInformationServiceType
    private let storage: RegisteredCatStorageType
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(
        catService: CatInformationServiceType = CatInformationService(),
        storage: RegisteredCatStorageType = UserDefaultsRegisteredCatStorage()
    ) {
        self.catService = catService
        self.storage = storage
        loadSavedCats()

        if !savedCats.isEmpty {
            isShowingForm = true
        }
    }

    // MARK: - Actions

    func loadSavedCats() {
        savedCats = storage.fetchAll()
    }

    func startAddingCat() {
        isShowingForm = true
    }

    func goBack() {
        guard canGoBack, let previousStep = Step(rawValue: currentStep.rawValue - 1) else { return }
        showValidationErrors = false
        currentStep = previousStep
    }

    func goForward() {
        guard validateCurrentStep() else {
            showValidationErrors = true
            return
        }

        showValidationErrors = false

        if isLastStep {
            saveCat()
        } else if let nextStep = Step(rawValue: currentStep.rawValue + 1) {
            currentStep = nextStep

            if nextStep == .breed, breeds.isEmpty {
                fetchBreeds()
            }
        }
    }

    func clearValidationErrors() {
        showValidationErrors = false
    }

    func selectBreed(_ selectedBreed: CatBreed) {
        breed = selectedBreed.name
    }

    func fetchBreeds() {
        guard !isLoadingBreeds else { return }

        isLoadingBreeds = true
        breedsErrorMessage = nil

        catService.getCatBreeds()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                self.isLoadingBreeds = false

                if case .failure(let error) = completion {
                    self.breedsErrorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] breeds in
                self?.breeds = breeds.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            }
            .store(in: &cancellables)
    }

    func saveCat() {
        guard
            canProceed,
            let ageValue = Int(age.trimmingCharacters(in: .whitespacesAndNewlines))
        else {
            return
        }

        let cat = RegisteredCat(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            breed: breed.trimmingCharacters(in: .whitespacesAndNewlines),
            age: ageValue,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        do {
            try storage.save(cat)
            loadSavedCats()
            showSaveConfirmation = true
            saveErrorMessage = nil
        } catch {
            saveErrorMessage = error.localizedDescription
        }
    }

    func resetForm() {
        currentStep = .name
        name = ""
        breed = ""
        age = ""
        description = ""
        saveErrorMessage = nil
        showValidationErrors = false
    }

    // MARK: - Private Helpers

    private func validateCurrentStep() -> Bool {
        validationError(for: currentStep) == nil
    }

    private func validationError(for step: Step) -> String? {
        switch step {
        case .name:
            return Validation.nameError(for: name)
        case .breed:
            return Validation.breedError(for: breed)
        case .age:
            return Validation.ageError(for: age)
        case .description:
            return Validation.descriptionError(for: description)
        }
    }
}
