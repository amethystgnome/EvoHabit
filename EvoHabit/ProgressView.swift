import SwiftUI

struct ProgressReportView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    var body: some View {
        NavigationView {
            VStack {
                if let user = authViewModel.currentUser, !user.habits.isEmpty {
                    ProgressBar(progress: calculateProgress(habits: user.habits))
                        .frame(height: 20)
                        .padding()

                    Text("\(user.habits.filter { $0.achieved }.count) out of \(user.habits.count) goals achieved")
                        .font(.largeTitle)
                } else {
                    Text("No habits tracked yet.")
                        .padding()
                }
                
                // Goals List
                List {
                    if let user = authViewModel.currentUser {
                        ForEach(user.habits) { habit in
                            HStack {
                                Text(habit.name)
                                Spacer()
                                Text(habit.achieved ? "Achieved" : "Unachieved")
                                    .foregroundColor(habit.achieved ? .green : .red)
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationTitle("Progress Report")
        }
    }
    
    func calculateProgress(habits: [Habit]) -> Double {
        guard !habits.isEmpty else { return 0.0 }
        let achievedHabits = habits.filter { $0.achieved }.count
        return Double(achievedHabits) / Double(habits.count)
    }
}


