//
//  EvoHabitApp.swift
//  EvoHabit
//
//  Created by Aubrianna Sample on 5/16/24.
//
import SwiftUI

@main
struct HabitTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(AuthenticationViewModel())
        }
    }
}



