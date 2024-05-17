import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                        .onAppear {
                            print("HomeView appeared")
                        }
                    
                    ProgressReportView()
                        .tabItem {
                            Image(systemName: "chart.bar")
                            Text("Progress")
                        }
                        .onAppear {
                            print("ProgressReportView appeared")
                        }
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .onAppear {
                            print("SettingsView appeared")
                        }
                }
                .accentColor(.purple)
            } else {
                AuthenticationView()
                    .environmentObject(authViewModel)
                    .onAppear {
                        print("AuthenticationView appeared, isAuthenticated: \(authViewModel.isAuthenticated)")
                    }
            }
        }
    }
}











