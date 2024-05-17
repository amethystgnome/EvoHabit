//
//  HomeView.swift
//  EvoHabit
//
//  Created by Aubrianna Sample on 5/16/24.
//
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var showingAddHabitSheet = false

    var body: some View {
        if let user = authViewModel.currentUser {
            NavigationView {
                VStack {
                    if !user.habits.isEmpty {
                        ProgressBar(progress: calculateProgress(habits: user.habits))
                            .frame(height: 20)
                            .padding()
                    } else {
                        Text("No habits added yet. Add some to start tracking!")
                            .padding()
                    }
                    
                    // Today's Goals List
                    List {
                        Section(header: Text("Today's Goals")) {
                            ForEach(user.habits) { habit in
                                HStack {
                                    Text(habit.name)
                                    Spacer()
                                    Image(systemName: habit.achieved ? "checkmark.circle.fill" : "circle")
                                        .onTapGesture {
                                            if let index = authViewModel.currentUser?.habits.firstIndex(where: { $0.id == habit.id }) {
                                                authViewModel.currentUser?.habits[index].achieved.toggle()
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                    
                    Spacer()
                    
                    // Add Habit Button
                    Button(action: {
                        showingAddHabitSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                    }
                    .sheet(isPresented: $showingAddHabitSheet) {
                        AddHabitView().environmentObject(authViewModel)
                    }
                }
                .navigationTitle("Hello, \(user.name)!")
            }
        } else {
            AuthenticationView()
                .environmentObject(authViewModel)
        }
    }
    
    func calculateProgress(habits: [Habit]) -> Double {
        guard !habits.isEmpty else { return 0.0 }
        let achievedHabits = habits.filter { $0.achieved }.count
        return Double(achievedHabits) / Double(habits.count)
    }
}






