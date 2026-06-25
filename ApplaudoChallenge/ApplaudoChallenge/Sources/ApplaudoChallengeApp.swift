import SwiftUI

@main
struct ApplaudoChallengeApp: App {
    @StateObject private var registeredCatsStore = RegisteredCatsStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(registeredCatsStore)
        }
    }
}
