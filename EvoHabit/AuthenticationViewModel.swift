//
//  AuthenticationViewModel.swift
//  EvoHabit
//
//  Created by Aubrianna Sample on 5/16/24.
//

import Foundation
import SwiftUI

class AuthenticationViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var authError: String?

    func signUp(name: String, email: String, password: String) {
        if DatabaseManager.shared.getUser(email: email, password: password) != nil {
            authError = "Email already exists."
            return
        }
        let newUser = User(name: name, email: email, password: password, habits: [])
        DatabaseManager.shared.addUser(newUser)
        currentUser = newUser
        isAuthenticated = true
    }

    func login(email: String, password: String) {
        if let user = DatabaseManager.shared.getUser(email: email, password: password) {
            currentUser = user
            isAuthenticated = true
            authError = nil
        } else {
            authError = "Invalid email or password."
            isAuthenticated = false
        }
    }

    func signOut() {
        currentUser = nil
        isAuthenticated = false
    }

    func addHabit(_ habit: Habit) {
        guard let currentUser = currentUser else { return }
        DatabaseManager.shared.addHabit(habit, for: currentUser.id.uuidString)
        self.currentUser?.habits.append(habit)
    }
}








