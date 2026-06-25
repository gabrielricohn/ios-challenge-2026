//
//  CatBreedsView.swift
//  NetworkLayer
//
//  Created by Gabriel Rico on 25/6/26.
//

import NetworkLayer
import SwiftUI

struct CatBreedsView: View {

    @StateObject private var viewModel = CatBreedsViewModel()
    @State private var selectedBreed: CatBreed?

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.breeds.isEmpty {
                ProgressView("Loading breeds...")
            } else if let errorMessage = viewModel.errorMessage, viewModel.breeds.isEmpty {
                EmptyStateView(
                    systemImage: "wifi.exclamationmark",
                    title: "Something Went Wrong",
                    message: errorMessage,
                    buttonTitle: "Try Again",
                    action: viewModel.fetchCatBreeds
                )
            } else if viewModel.isEmpty {
                EmptyStateView(
                    systemImage: "cat",
                    title: "No Breeds Found",
                    message: "We couldn't find any cat breeds to display.",
                    buttonTitle: "Refresh",
                    action: viewModel.fetchCatBreeds
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: AppTheme.Spacing.sm) {
                        ForEach(viewModel.breeds) { breed in
                            AppCard(
                                title: breed.name,
                                subtitle: breed.description,
                                imageSystemName: "cat"
                            )
                            .onTapGesture {
                                print("cell tapped")
                                selectedBreed = breed
                            }
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.vertical, AppTheme.Spacing.sm)
                }
                .refreshable {
                    viewModel.fetchCatBreeds()
                }
            }
        }
        .navigationTitle("Cat Breeds")
        .navigationDestination(item: $selectedBreed) { breed in
            
        }
        .task {
            if viewModel.breeds.isEmpty {
                viewModel.fetchCatBreeds()
            }
        }
    }
}

#Preview {
    NavigationStack {
        CatBreedsView()
    }
}
