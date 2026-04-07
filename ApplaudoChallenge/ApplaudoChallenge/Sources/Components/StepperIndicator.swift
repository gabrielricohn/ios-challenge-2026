import SwiftUI

struct StepperIndicator: View {

    let currentStep: Int
    let totalSteps: Int
    let stepTitles: [String]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<totalSteps, id: \.self) { index in
                stepCircle(for: index)

                if index < totalSteps - 1 {
                    connector(after: index)
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
    }

    // MARK: - Step Circle

    @ViewBuilder
    private func stepCircle(for index: Int) -> some View {
        let state = stepState(for: index)

        VStack(spacing: AppTheme.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(state.backgroundColor)
                    .frame(width: 36, height: 36)

                Circle()
                    .stroke(state.borderColor, lineWidth: 2)
                    .frame(width: 36, height: 36)

                if state == .completed {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Text("\(index + 1)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(state.textColor)
                }
            }

            if index < stepTitles.count {
                Text(stepTitles[index])
                    .font(AppTheme.Fonts.caption)
                    .foregroundColor(state == .active ? AppTheme.Colors.textPrimary : AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .frame(width: 70)
            }
        }
    }

    // MARK: - Connector Line

    private func connector(after index: Int) -> some View {
        Rectangle()
            .fill(index < currentStep ? AppTheme.Colors.success : AppTheme.Colors.border)
            .frame(height: 2)
            .frame(maxWidth: .infinity)
            .padding(.bottom, stepTitles.isEmpty ? 0 : 28)
    }

    // MARK: - Step State

    private enum StepState {
        case completed, active, pending

        var backgroundColor: Color {
            switch self {
            case .completed: return AppTheme.Colors.success
            case .active: return AppTheme.Colors.primary
            case .pending: return .clear
            }
        }

        var borderColor: Color {
            switch self {
            case .completed: return AppTheme.Colors.success
            case .active: return AppTheme.Colors.primary
            case .pending: return AppTheme.Colors.border
            }
        }

        var textColor: Color {
            switch self {
            case .completed: return .white
            case .active: return .white
            case .pending: return AppTheme.Colors.textSecondary
            }
        }
    }

    private func stepState(for index: Int) -> StepState {
        if index < currentStep { return .completed }
        if index == currentStep { return .active }
        return .pending
    }
}

// MARK: - Preview

#Preview("Stepper Indicator") {
    VStack(spacing: AppTheme.Spacing.xl) {
        StepperIndicator(
            currentStep: 1,
            totalSteps: 3,
            stepTitles: ["Basic Info", "Details", "Review"]
        )

        StepperIndicator(
            currentStep: 2,
            totalSteps: 3,
            stepTitles: ["Basic Info", "Details", "Review"]
        )

        StepperIndicator(
            currentStep: 0,
            totalSteps: 3,
            stepTitles: ["Basic Info", "Details", "Review"]
        )
    }
    .padding(AppTheme.Spacing.lg)
}
