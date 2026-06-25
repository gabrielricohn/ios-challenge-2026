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
        switch currentStep {
        case .name:
            return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .breed:
            return !breed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .age:
            guard let ageValue = Int(age.trimmingCharacters(in: .whitespacesAndNewlines)) else {
                return false
            }
            return ageValue > 0
        case .description:
            return !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
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
        currentStep = previousStep
    }

    func goForward() {
        guard canProceed else { return }

        if isLastStep {
            saveCat()
        } else if let nextStep = Step(rawValue: currentStep.rawValue + 1) {
            currentStep = nextStep

            if nextStep == .breed, breeds.isEmpty {
                fetchBreeds()
            }
        }
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
    }
}
