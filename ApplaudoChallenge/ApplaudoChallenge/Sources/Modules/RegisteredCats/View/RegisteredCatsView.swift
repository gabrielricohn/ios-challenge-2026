//
//  RegisteredCatsView.swift
//  ApplaudoChallenge
//
//  Created by Gabriel Rico on 25/6/26.
//

import SwiftUI

struct RegisteredCatsView: View {

    @EnvironmentObject private var registeredCatsStore: RegisteredCatsStore
    @Binding var selectedTab: AppTab
    @State private var selectedCat: RegisteredCat?

    var body: some View {
        Group {
            if registeredCatsStore.cats.isEmpty {
                EmptyStateView(
                    systemImage: "cat",
                    title: "No Cats Yet",
                    message: "Start by adding your first cat breed to the collection.",
                    buttonTitle: "Add a Cat",
                    action: { selectedTab = .addCat }
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: AppTheme.Spacing.sm) {
                        ForEach(registeredCatsStore.cats) { cat in
                            AppCard(
                                title: cat.name,
                                subtitle: cat.description,
                                imageSystemName: "cat.fill"
                            )
                            .onTapGesture {
                                selectedCat = cat
                            }
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.vertical, AppTheme.Spacing.sm)
                }
                .refreshable {
                    registeredCatsStore.refresh()
                }
            }
        }
        .navigationTitle("My Cats")
        .navigationDestination(item: $selectedCat) { cat in
            RegisteredCatDetailView(cat: cat)
        }
        .onAppear {
            registeredCatsStore.refresh()
        }
    }
}

#Preview {
    @Previewable @State var selectedTab: AppTab = .myCats

    NavigationStack {
        RegisteredCatsView(selectedTab: $selectedTab)
    }
    .environmentObject(RegisteredCatsStore())
}
