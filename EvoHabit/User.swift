import Foundation

struct User: Identifiable {
    let id: UUID
    var name: String
    var email: String
    var password: String
    var habits: [Habit]
    var completedDays: [Date] // Add this property to track completed days
}

