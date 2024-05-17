import Foundation
import SwiftUI

class AuthenticationViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var authError: String?

    init() {
        print("AuthenticationViewModel initialized")
        print("Initial isAuthenticated: \(isAuthenticated)")
    }

    func signUp(name: String, email: String, password: String) {
        print("signUp called")
        if DatabaseManager.shared.getUser(email: email, password: password) != nil {
            authError = "Email already exists."
            clearAuthErrorAfterDelay()
            return
        }
        let newUser = User(id: UUID(), name: name, email: email, password: password, habits: [], completedDays: [])
        DatabaseManager.shared.addUser(newUser)
        currentUser = newUser
        isAuthenticated = true
        print("User signed up, isAuthenticated: \(isAuthenticated)")
    }

    func login(email: String, password: String) {
        print("login called")
        if let user = DatabaseManager.shared.getUser(email: email, password: password) {
            currentUser = user
            isAuthenticated = true
            authError = nil
            print("User logged in, isAuthenticated: \(isAuthenticated)")
        } else {
            authError = "Invalid email or password."
            clearAuthErrorAfterDelay()
            isAuthenticated = false
            print("Login failed, isAuthenticated: \(isAuthenticated)")
        }
    }

    func signOut() {
        currentUser = nil
        isAuthenticated = false
        print("User signed out, isAuthenticated: \(isAuthenticated)")
    }

    func addHabit(_ habit: Habit) {
        guard let currentUser = currentUser else { return }
        DatabaseManager.shared.addHabit(habit, for: currentUser.id.uuidString)
        var updatedUser = currentUser
        updatedUser.habits.append(habit)
        self.currentUser = updatedUser
    }

    func deleteHabit(_ habit: Habit) {
        guard let currentUser = currentUser else { return }
        DatabaseManager.shared.deleteHabit(habit)
        var updatedUser = currentUser
        updatedUser.habits.removeAll { $0.id == habit.id }
        self.currentUser = updatedUser
    }

    func deleteAllHabits() {
        guard let currentUser = currentUser else { return }
        DatabaseManager.shared.deleteAllHabits(for: currentUser.id.uuidString)
        var updatedUser = currentUser
        updatedUser.habits.removeAll()
        self.currentUser = updatedUser
    }

    func toggleHabitAchieved(_ habit: Habit) {
        guard let currentUser = currentUser else { return }
        var updatedUser = currentUser
        if let index = updatedUser.habits.firstIndex(where: { $0.id == habit.id }) {
            updatedUser.habits[index].achieved.toggle()
            DatabaseManager.shared.updateHabitAchieved(updatedUser.habits[index])
            if updatedUser.habits.allSatisfy({ $0.achieved }) {
                DatabaseManager.shared.addCompletedDay(for: updatedUser.id.uuidString, date: Date())
                updatedUser.completedDays.append(Date())
            }
        }
        self.currentUser = updatedUser
    }

    func getCompletedDays() -> [Date] {
        guard let currentUser = currentUser else { return [] }
        return DatabaseManager.shared.getCompletedDays(for: currentUser.id.uuidString)
    }
    
    private func clearAuthErrorAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.authError = nil
        }
    }
}













