//
//  MainTabView.swift
//  EvoHabit
//
//  Created by Aubrianna Sample on 5/16/24.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var authViewModel = AuthenticationViewModel()

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                        .environmentObject(authViewModel)
                    
                    ProgressReportView()
                        .tabItem {
                            Image(systemName: "chart.bar")
                            Text("Progress")
                        }
                        .environmentObject(authViewModel)
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .environmentObject(authViewModel)
                }
                .accentColor(.purple)
            } else {
                AuthenticationView()
                    .environmentObject(authViewModel)
            }
        }
    }
}







