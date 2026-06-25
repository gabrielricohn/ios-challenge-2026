import SwiftUI

public struct ContentView: View {
    @State private var selectedTab: AppTab = .breeds

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            // MARK: - Tab 1: Cat List
            NavigationStack {
                CatBreedsView()
            }
            .tabItem {
                Label("Cats", systemImage: "cat")
            }
            .tag(AppTab.breeds)

            // MARK: - Tab 2: Saved Cats
            NavigationStack {
                RegisteredCatsView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("My Cats", systemImage: "heart.fill")
            }
            .tag(AppTab.myCats)

            // MARK: - Tab 3: Add Cat
            NavigationStack {
                AddCatView()
            }
            .tabItem {
                Label("Add Cat", systemImage: "plus.circle")
            }
            .tag(AppTab.addCat)
        }
        .tint(AppTheme.Colors.primary)
    }
}

#Preview {
    ContentView()
        .environmentObject(RegisteredCatsStore())
}
