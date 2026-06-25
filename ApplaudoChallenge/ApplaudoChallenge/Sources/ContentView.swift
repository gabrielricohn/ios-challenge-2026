import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        TabView {
            // MARK: - Tab 1: Cat List
            NavigationStack {
                CatBreedsView()
            }
            .tabItem {
                Label("Cats", systemImage: "cat")
            }

            // MARK: - Tab 2: Add Cat
            NavigationStack {
                AddCatView()
            }
            .tabItem {
                Label("Add Cat", systemImage: "plus.circle")
            }
        }
        .tint(AppTheme.Colors.primary)
    }
}

#Preview {
    ContentView()
}
