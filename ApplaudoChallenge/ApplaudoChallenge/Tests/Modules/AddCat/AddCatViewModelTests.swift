//
//  AddCatViewModelTests.swift
//  ApplaudoChallengeTests
//
//  Created by Gabriel Rico on 25/6/26.
//

import Foundation
import NetworkLayer
import Testing
@testable import ApplaudoChallenge

@MainActor
struct AddCatViewModelTests {

    private func makeViewModel(
        catService: MockCatInformationService = MockCatInformationService(),
        storage: MockRegisteredCatStorage = MockRegisteredCatStorage()
    ) -> AddCatViewModel {
        AddCatViewModel(catService: catService, storage: storage)
    }

    @Test func initShowsEmptyStateWhenNoSavedCatsExist() {
        let viewModel = makeViewModel()

        #expect(viewModel.savedCats.isEmpty)
        #expect(viewModel.isShowingForm == false)
        #expect(viewModel.shouldShowEmptyState == true)
    }

    @Test func initShowsFormWhenSavedCatsExist() {
        let storage = MockRegisteredCatStorage()
        storage.savedCats = [AddCatTestFixtures.sampleCat]

        let viewModel = makeViewModel(storage: storage)

        #expect(viewModel.savedCats.count == 1)
        #expect(viewModel.isShowingForm == true)
        #expect(viewModel.shouldShowEmptyState == false)
    }

    @Test func startAddingCatShowsForm() {
        let viewModel = makeViewModel()

        viewModel.startAddingCat()

        #expect(viewModel.isShowingForm == true)
        #expect(viewModel.shouldShowEmptyState == false)
    }

    @Test func canProceedValidatesNameStep() {
        let viewModel = makeViewModel()

        viewModel.name = "   "
        #expect(viewModel.canProceed == false)

        viewModel.name = "L"
        #expect(viewModel.canProceed == false)

        viewModel.name = "Luna"
        #expect(viewModel.canProceed == true)
    }

    @Test func canProceedValidatesBreedStep() {
        let viewModel = makeViewModel()
        viewModel.currentStep = .breed

        viewModel.breed = "   "
        #expect(viewModel.canProceed == false)

        viewModel.breed = "Persian"
        #expect(viewModel.canProceed == true)
    }

    @Test func canProceedValidatesAgeStep() {
        let viewModel = makeViewModel()
        viewModel.currentStep = .age

        viewModel.age = "abc"
        #expect(viewModel.canProceed == false)

        viewModel.age = "0"
        #expect(viewModel.canProceed == false)

        viewModel.age = "3"
        #expect(viewModel.canProceed == true)
    }

    @Test func canProceedValidatesDescriptionStep() {
        let viewModel = makeViewModel()
        viewModel.currentStep = .description

        viewModel.description = "   "
        #expect(viewModel.canProceed == false)

        viewModel.description = "A friendly cat."
        #expect(viewModel.canProceed == true)
    }

    @Test func goForwardAdvancesStepsWhenValid() {
        let viewModel = makeViewModel()
        viewModel.name = "Luna"

        viewModel.goForward()
        #expect(viewModel.currentStep == .breed)

        viewModel.breed = "Persian"
        viewModel.goForward()
        #expect(viewModel.currentStep == .age)

        viewModel.age = "3"
        viewModel.goForward()
        #expect(viewModel.currentStep == .description)
    }

    @Test func goForwardDoesNotAdvanceWhenInvalid() {
        let viewModel = makeViewModel()

        viewModel.goForward()

        #expect(viewModel.currentStep == .name)
        #expect(viewModel.showValidationErrors == true)
        #expect(viewModel.nameValidationError == "Name is required.")
    }

    @Test func goForwardClearsValidationErrorsWhenStepIsValid() {
        let viewModel = makeViewModel()
        viewModel.goForward()
        #expect(viewModel.showValidationErrors == true)

        viewModel.name = "Luna"
        viewModel.goForward()

        #expect(viewModel.currentStep == .breed)
        #expect(viewModel.showValidationErrors == false)
    }

    @Test func nameValidationErrorRequiresMinimumLength() {
        let viewModel = makeViewModel()
        viewModel.name = "L"
        viewModel.goForward()

        #expect(viewModel.nameValidationError == "Name must be at least 2 characters.")
    }

    @Test func ageValidationErrorForNonNumericInput() {
        let viewModel = makeViewModel()
        viewModel.currentStep = .age
        viewModel.age = "abc"
        viewModel.goForward()

        #expect(viewModel.ageValidationError == "Age must be a valid number.")
    }

    @Test func clearValidationErrorsHidesInlineMessages() {
        let viewModel = makeViewModel()
        viewModel.goForward()
        #expect(viewModel.nameValidationError != nil)

        viewModel.clearValidationErrors()

        #expect(viewModel.showValidationErrors == false)
        #expect(viewModel.nameValidationError == nil)
    }

    @Test func goBackReturnsToPreviousStep() {
        let viewModel = makeViewModel()
        viewModel.currentStep = .age

        viewModel.goBack()

        #expect(viewModel.currentStep == .breed)
    }

    @Test func goBackDoesNothingOnFirstStep() {
        let viewModel = makeViewModel()

        viewModel.goBack()

        #expect(viewModel.currentStep == .name)
        #expect(viewModel.canGoBack == false)
    }

    @Test func primaryButtonTitleChangesOnLastStep() {
        let viewModel = makeViewModel()

        #expect(viewModel.primaryButtonTitle == "Continue")

        viewModel.currentStep = .description
        #expect(viewModel.primaryButtonTitle == "Save Cat")
    }

    @Test func selectBreedSetsBreedName() {
        let viewModel = makeViewModel()

        viewModel.selectBreed(AddCatTestFixtures.persianBreed)

        #expect(viewModel.breed == "Persian")
    }

    @Test func filteredBreedsReturnsAllBreedsWhenQueryIsEmpty() {
        let viewModel = makeViewModel()
        viewModel.breeds = [
            AddCatTestFixtures.persianBreed,
            AddCatTestFixtures.siameseBreed
        ]

        #expect(viewModel.filteredBreeds.count == 2)
    }

    @Test func filteredBreedsFiltersByName() {
        let viewModel = makeViewModel()
        viewModel.breeds = [
            AddCatTestFixtures.persianBreed,
            AddCatTestFixtures.siameseBreed,
            AddCatTestFixtures.abyssinianBreed
        ]
        viewModel.breed = "Siamese"

        #expect(viewModel.filteredBreeds.count == 1)
        #expect(viewModel.filteredBreeds.first?.name == "Siamese")
    }

    @Test func saveCatPersistsEntryAndShowsConfirmation() {
        let storage = MockRegisteredCatStorage()
        let viewModel = makeViewModel(storage: storage)
        viewModel.name = "Luna"
        viewModel.breed = "Persian"
        viewModel.age = "3"
        viewModel.description = "A calm cat."
        viewModel.currentStep = .description

        viewModel.saveCat()

        #expect(storage.savedCats.count == 1)
        #expect(storage.savedCats.first?.name == "Luna")
        #expect(storage.savedCats.first?.breed == "Persian")
        #expect(storage.savedCats.first?.age == 3)
        #expect(storage.savedCats.first?.description == "A calm cat.")
        #expect(viewModel.savedCats.count == 1)
        #expect(viewModel.showSaveConfirmation == true)
        #expect(viewModel.saveErrorMessage == nil)
    }

    @Test func saveCatSetsErrorMessageWhenStorageFails() {
        let storage = MockRegisteredCatStorage()
        storage.saveError = RegisteredCatStorageError.encodingFailed
        let viewModel = makeViewModel(storage: storage)
        viewModel.name = "Luna"
        viewModel.breed = "Persian"
        viewModel.age = "3"
        viewModel.description = "A calm cat."
        viewModel.currentStep = .description

        viewModel.saveCat()

        #expect(storage.savedCats.isEmpty)
        #expect(viewModel.showSaveConfirmation == false)
        #expect(viewModel.saveErrorMessage == RegisteredCatStorageError.encodingFailed.localizedDescription)
    }

    @Test func resetFormClearsFieldsAndReturnsToFirstStep() {
        let viewModel = makeViewModel()
        viewModel.currentStep = .description
        viewModel.name = "Luna"
        viewModel.breed = "Persian"
        viewModel.age = "3"
        viewModel.description = "A calm cat."
        viewModel.saveErrorMessage = "Error"

        viewModel.resetForm()

        #expect(viewModel.currentStep == .name)
        #expect(viewModel.name.isEmpty)
        #expect(viewModel.breed.isEmpty)
        #expect(viewModel.age.isEmpty)
        #expect(viewModel.description.isEmpty)
        #expect(viewModel.saveErrorMessage == nil)
    }

    @Test func loadSavedCatsRefreshesPublishedState() {
        let storage = MockRegisteredCatStorage()
        let viewModel = makeViewModel(storage: storage)

        storage.savedCats = [AddCatTestFixtures.sampleCat]
        viewModel.loadSavedCats()

        #expect(viewModel.savedCats == [AddCatTestFixtures.sampleCat])
    }

    @Test func fetchBreedsLoadsBreedsFromService() async {
        let service = MockCatInformationService()
        service.breedsResult = .success([
            AddCatTestFixtures.siameseBreed,
            AddCatTestFixtures.persianBreed
        ])
        let viewModel = makeViewModel(catService: service)

        viewModel.fetchBreeds()
        try? await Task.sleep(for: .milliseconds(50))

        #expect(viewModel.isLoadingBreeds == false)
        #expect(viewModel.breeds.count == 2)
        #expect(viewModel.breeds.first?.name == "Persian")
        #expect(viewModel.breeds.last?.name == "Siamese")
        #expect(viewModel.breedsErrorMessage == nil)
    }

    @Test func fetchBreedsSetsErrorMessageOnFailure() async {
        let service = MockCatInformationService()
        service.breedsResult = .failure(.serverError(statusCode: 500, data: Data()))
        let viewModel = makeViewModel(catService: service)

        viewModel.fetchBreeds()
        try? await Task.sleep(for: .milliseconds(50))

        #expect(viewModel.isLoadingBreeds == false)
        #expect(viewModel.breeds.isEmpty)
        #expect(viewModel.breedsErrorMessage == NetworkError.serverError(statusCode: 500, data: Data()).localizedDescription)
    }

    @Test func goForwardToBreedStepTriggersBreedFetch() async {
        let service = MockCatInformationService()
        service.breedsResult = .success([AddCatTestFixtures.persianBreed])
        let viewModel = makeViewModel(catService: service)
        viewModel.name = "Luna"

        viewModel.goForward()
        try? await Task.sleep(for: .milliseconds(50))

        #expect(viewModel.currentStep == .breed)
        #expect(viewModel.breeds.count == 1)
        #expect(viewModel.breeds.first?.name == "Persian")
    }
}
