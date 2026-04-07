import SwiftUI

struct SectionHeader: View {

    let title: String
    var subtitle: String?
    var systemImage: String = "square.grid.2x2"

    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundColor(AppTheme.Colors.primary)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(AppTheme.Fonts.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }

            Spacer()
        }
    }
}

// MARK: - Preview

#Preview("Section Header") {
    VStack(spacing: AppTheme.Spacing.lg) {
        SectionHeader(
            title: "Breed Information",
            subtitle: "Fill in the basic details",
            systemImage: "info.circle"
        )

        SectionHeader(
            title: "Appearance",
            systemImage: "paintpalette"
        )
    }
    .padding(AppTheme.Spacing.lg)
}
