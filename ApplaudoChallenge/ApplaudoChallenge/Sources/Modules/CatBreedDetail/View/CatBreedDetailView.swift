//
//  CatBreedDetailView.swift
//  ApplaudoChallenge
//
//  Created by Gabriel Rico on 25/6/26.
//

import SwiftUI

struct CatBreedDetailView: View {

    @ObservedObject var viewModel: CatBreedDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                breedImage

                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    SectionHeader(
                        title: "About",
                        systemImage: "text.alignleft"
                    )

                    Text(viewModel.breed.description)
                        .font(AppTheme.Fonts.body)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    SectionHeader(
                        title: "Details",
                        systemImage: "info.circle"
                    )

                    DetailInfoRow(title: "Origin", value: viewModel.breed.origin)
                    DetailInfoRow(title: "Temperament", value: viewModel.breed.temperament)
                    DetailInfoRow(title: "Life Span", value: viewModel.formattedLifeSpan)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
        }
        .background(AppTheme.Colors.background)
        .navigationTitle(viewModel.breed.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var breedImage: some View {
        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
            .fill(AppTheme.Colors.surface)
            .frame(maxWidth: .infinity)
            .frame(height: 240)
            .overlay {
                Group {
                    if let imageURL = viewModel.imageURL {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .empty:
                                imagePlaceholder(showProgress: true)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                imagePlaceholder(showProgress: false)
                            @unknown default:
                                imagePlaceholder(showProgress: false)
                            }
                        }
                    } else {
                        imagePlaceholder(showProgress: false)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
    }

    private func imagePlaceholder(showProgress: Bool) -> some View {
        ZStack {
            AppTheme.Colors.surface

            if showProgress {
                ProgressView()
            } else {
                Image(systemName: "cat.fill")
                    .font(.system(size: 48))
                    .foregroundColor(AppTheme.Colors.primary.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
