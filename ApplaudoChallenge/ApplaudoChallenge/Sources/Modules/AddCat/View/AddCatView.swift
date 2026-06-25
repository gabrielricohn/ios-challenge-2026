//
//  AddCatView.swift
//  ApplaudoChallenge
//
//  Created by Gabriel Rico on 25/6/26.
//

import NetworkLayer
import SwiftUI

struct AddCatView: View {

    @EnvironmentObject private var registeredCatsStore: RegisteredCatsStore
    @StateObject private var viewModel = AddCatViewModel()

    var body: some View {
        formContent
            .background(AppTheme.Colors.background)
        .navigationTitle("Add Cat")
        .alert("Cat Saved!", isPresented: $viewModel.showSaveConfirmation) {
            Button("OK") {
                viewModel.resetForm()
            }
        } message: {
            Text("Your cat has been saved locally and will be available after restarting the app.")
        }
        .alert(
            "Unable to Save",
            isPresented: saveErrorBinding,
            presenting: viewModel.saveErrorMessage
        ) { _ in
            Button("OK", role: .cancel) {}
        } message: { message in
            Text(message)
        }
        .onAppear {
            viewModel.loadSavedCats()
            registeredCatsStore.refresh()

            if viewModel.currentStep == .breed, viewModel.breeds.isEmpty {
                viewModel.fetchBreeds()
            }
        }
        .onChange(of: viewModel.savedCats) { _, _ in
            registeredCatsStore.refresh()
        }
    }

    // MARK: - Form Content

    private var formContent: some View {
        VStack(spacing: 0) {
            StepperIndicator(
                currentStep: viewModel.currentStepIndex,
                totalSteps: viewModel.totalSteps,
                stepTitles: viewModel.stepTitles
            )
            .padding(.vertical, AppTheme.Spacing.lg)

            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    SectionHeader(
                        title: viewModel.currentStep.headerTitle,
                        subtitle: viewModel.currentStep.headerSubtitle,
                        systemImage: viewModel.currentStep.systemImage
                    )

                    stepContent
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.lg)
            }

            navigationButtons
        }
    }

    // MARK: - Step Content

    @ViewBuilder
    private var stepContent: some View {
        switch viewModel.currentStep {
        case .name:
            AppTextField(
                label: "Name",
                placeholder: "Enter your cat's name",
                text: $viewModel.name,
                errorMessage: viewModel.nameValidationError,
                icon: "pawprint"
            )
            .onChange(of: viewModel.name) { _, _ in
                viewModel.clearValidationErrors()
            }

        case .breed:
            breedStepContent

        case .age:
            AppTextField(
                label: "Age (years)",
                placeholder: "Enter age in years",
                text: $viewModel.age,
                errorMessage: viewModel.ageValidationError,
                keyboardType: .numberPad,
                icon: "calendar"
            )
            .onChange(of: viewModel.age) { _, _ in
                viewModel.clearValidationErrors()
            }

        case .description:
            descriptionStepContent
        }
    }

    @ViewBuilder
    private var breedStepContent: some View {
        AppTextField(
            label: "Breed",
            placeholder: "Search or type a breed",
            text: $viewModel.breed,
            errorMessage: viewModel.breedValidationError,
            icon: "cat"
        )
        .onChange(of: viewModel.breed) { _, _ in
            viewModel.clearValidationErrors()
        }

        if viewModel.isLoadingBreeds {
            ProgressView("Loading breeds...")
                .frame(maxWidth: .infinity)
                .padding(.top, AppTheme.Spacing.sm)
        } else if let errorMessage = viewModel.breedsErrorMessage {
            EmptyStateView(
                systemImage: "wifi.exclamationmark",
                title: "Couldn't Load Breeds",
                message: errorMessage,
                buttonTitle: "Try Again",
                action: viewModel.fetchBreeds
            )
            .frame(minHeight: 220)
        } else if !viewModel.filteredBreeds.isEmpty {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("Suggestions")
                    .font(AppTheme.Fonts.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)

                LazyVStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(viewModel.filteredBreeds.prefix(8)) { breed in
                        AppCard(
                            title: breed.name,
                            subtitle: breed.origin,
                            imageSystemName: "cat",
                            showChevron: false
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .stroke(
                                    viewModel.breed == breed.name ? AppTheme.Colors.primary : .clear,
                                    lineWidth: 2
                                )
                        )
                        .onTapGesture {
                            viewModel.selectBreed(breed)
                        }
                    }
                }
            }
        }
    }

    private var descriptionStepContent: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text("Description")
                .font(AppTheme.Fonts.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)

            TextEditor(text: $viewModel.description)
                .font(AppTheme.Fonts.body)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .frame(minHeight: 120)
                .padding(AppTheme.Spacing.sm)
                .background(AppTheme.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                        .stroke(
                            viewModel.descriptionValidationError == nil
                                ? AppTheme.Colors.border
                                : AppTheme.Colors.error,
                            lineWidth: 1
                        )
                )
                .scrollContentBackground(.hidden)
                .onChange(of: viewModel.description) { _, _ in
                    viewModel.clearValidationErrors()
                }

            if let errorMessage = viewModel.descriptionValidationError {
                HStack(spacing: AppTheme.Spacing.xs) {
                    Image(systemName: "exclamationmark.circle")
                        .font(.caption)
                    Text(errorMessage)
                        .font(AppTheme.Fonts.caption)
                }
                .foregroundColor(AppTheme.Colors.error)
            }

            reviewSummary
        }
    }

    private var reviewSummary: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            SectionHeader(
                title: "Review",
                subtitle: "Confirm the details before saving",
                systemImage: "checkmark.circle"
            )

            AppCard(
                title: viewModel.name.isEmpty ? "—" : viewModel.name,
                subtitle: summarySubtitle,
                imageSystemName: "cat.fill",
                showChevron: false
            )
        }
    }

    private var summarySubtitle: String {
        let breedText = viewModel.breed.isEmpty ? "Unknown breed" : viewModel.breed
        let ageText = viewModel.age.isEmpty ? "—" : "\(viewModel.age) years"
        return "\(breedText) · \(ageText)"
    }

    // MARK: - Navigation

    private var navigationButtons: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            if viewModel.canGoBack {
                AppButton(title: "Back", style: .secondary) {
                    viewModel.goBack()
                }
            }

            AppButton(title: viewModel.primaryButtonTitle) {
                viewModel.goForward()
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.md)
        .background(AppTheme.Colors.background)
    }

    private var saveErrorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.saveErrorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.saveErrorMessage = nil
                }
            }
        )
    }
}

#Preview {
    NavigationStack {
        AddCatView()
    }
    .environmentObject(RegisteredCatsStore())
}
