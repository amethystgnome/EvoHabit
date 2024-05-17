import SwiftUI

@main
struct HabitTrackerApp: App {
    @StateObject private var authViewModel = AuthenticationViewModel()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(authViewModel)
                .onAppear {
                    print("MainTabView appeared")
                }
        }
    }
}


