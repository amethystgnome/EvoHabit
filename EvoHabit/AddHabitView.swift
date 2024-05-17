import SwiftUI

struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    @State private var name: String = ""
    @State private var period: String = "1 Month (30 Days)"
    @State private var type: String = "Everyday"

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Habit Details")) {
                    TextField("Habit Name", text: $name)
                    Picker("Period", selection: $period) {
                        Text("1 Month (30 Days)").tag("1 Month (30 Days)")
                        Text("3 Months (90 Days)").tag("3 Months (90 Days)")
                        Text("6 Months (180 Days)").tag("6 Months (180 Days)")
                    }
                    Picker("Habit Type", selection: $type) {
                        Text("Everyday").tag("Everyday")
                        Text("Every Week").tag("Every Week")
                        Text("Every Month").tag("Every Month")
                    }
                }
                
                Section {
                    Button("Add Habit") {
                        let newHabit = Habit(
                            name: name,
                            period: period,
                            type: type,
                            target: 30,
                            progress: 0,
                            startDate: Date(),
                            endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
                            achieved: false
                        )
                        authViewModel.addHabit(newHabit)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle("Add New Habit")
        }
    }
}







