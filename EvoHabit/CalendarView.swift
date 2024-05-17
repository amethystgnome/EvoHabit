import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter
    private let monthYearFormatter: DateFormatter
    
    @State private var currentMonth: Date = Date()
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        
        monthYearFormatter = DateFormatter()
        monthYearFormatter.dateFormat = "MMMM yyyy" // Format for "May 2024"
    }
    
    var body: some View {
        VStack {
            Text(monthYearFormatter.string(from: currentMonth)) // Display current month and year
                .font(.title)
                .padding(.bottom)
            
            // Weekday Header
            let daysOfWeek = calendar.shortWeekdaySymbols
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 5)
            
            // Dates Grid
            let dates = generateDates(for: currentMonth)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(dates, id: \.self) { date in
                    if calendar.isDateInToday(date) {
                        Text(dateFormatter.string(from: date))
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.3))
                            .clipShape(Circle())
                    } else {
                        Text(dateFormatter.string(from: date))
                            .frame(maxWidth: .infinity)
                            .background(isCompletedDay(date) ? Color.green.opacity(0.3) : Color.clear)
                            .clipShape(Circle())
                    }
                }
            }
            .padding()
            
            if authViewModel.currentUser?.habits.isEmpty ?? true {
                Text("No habits tracked yet.")
                    .padding()
            } else {
                // Display habit progress details here if needed
            }
        }
        .padding()
        .onAppear {
            print("CalendarView appeared")
        }
    }
    
    private func generateDates(for month: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else {
            return []
        }

        var dates = [Date]()
        var date = monthInterval.start

        // Add padding dates for the first week
        let weekday = calendar.component(.weekday, from: date)
        for _ in 1..<weekday {
            dates.append(Date.distantPast)
        }

        while date < monthInterval.end {
            dates.append(date)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: date) else { break }
            date = nextDate
        }

        return dates
    }
    
    private func isCompletedDay(_ date: Date) -> Bool {
        guard let completedDays = authViewModel.currentUser?.completedDays else { return false }
        return completedDays.contains { calendar.isDate($0, inSameDayAs: date) }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView().environmentObject(AuthenticationViewModel())
    }
}


