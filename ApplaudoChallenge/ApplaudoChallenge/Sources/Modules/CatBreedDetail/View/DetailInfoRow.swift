//
//  DetailInfoRow.swift
//  ApplaudoChallenge
//
//  Created by Gabriel Rico on 25/6/26.
//

import SwiftUI

struct DetailInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(title)
                .font(AppTheme.Fonts.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)

            Text(value)
                .font(AppTheme.Fonts.body)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
    }
}

#Preview {
    DetailInfoRow(title: "testTitle", value: "testValue")
}
