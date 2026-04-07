import SwiftUI

struct EmptyStateView: View {

    let systemImage: String
    let title: String
    let message: String
    var buttonTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Spacer()

            Image(systemName: systemImage)
                .font(.system(size: 64))
                .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.5))

            Text(title)
                .font(AppTheme.Fonts.title)
                .foregroundColor(AppTheme.Colors.textPrimary)

            Text(message)
                .font(AppTheme.Fonts.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.Spacing.xl)

            if let buttonTitle, let action {
                AppButton(title: buttonTitle, style: .primary, action: action)
                    .padding(.horizontal, AppTheme.Spacing.xl)
                    .padding(.top, AppTheme.Spacing.sm)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

#Preview("Empty State") {
    EmptyStateView(
        systemImage: "cat",
        title: "No Cats Yet",
        message: "Start by adding your first cat breed to the collection.",
        buttonTitle: "Add a Cat",
        action: {}
    )
}
