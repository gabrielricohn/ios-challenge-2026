//
//  RegisteredCatDetailView.swift
//  ApplaudoChallenge
//
//  Created by Gabriel Rico on 25/6/26.
//

import SwiftUI

struct RegisteredCatDetailView: View {

    let cat: RegisteredCat

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                catImage

                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    SectionHeader(
                        title: "About",
                        systemImage: "text.alignleft"
                    )

                    Text(cat.description)
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

                    DetailInfoRow(title: "Breed", value: cat.breed)
                    DetailInfoRow(title: "Age", value: "\(cat.age) years")
                    DetailInfoRow(title: "Registered", value: formattedCreatedAt)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
        }
        .background(AppTheme.Colors.background)
        .navigationTitle(cat.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var catImage: some View {
        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
            .fill(AppTheme.Colors.surface)
            .frame(maxWidth: .infinity)
            .frame(height: 240)
            .overlay {
                Image(systemName: "cat.fill")
                    .font(.system(size: 48))
                    .foregroundColor(AppTheme.Colors.primary.opacity(0.5))
            }
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
    }

    private var formattedCreatedAt: String {
        cat.createdAt.formatted(date: .abbreviated, time: .omitted)
    }
}

#Preview {
    NavigationStack {
        RegisteredCatDetailView(
            cat: RegisteredCat(
                name: "Luna",
                breed: "Persian",
                age: 3,
                description: "A calm and affectionate companion."
            )
        )
    }
}
