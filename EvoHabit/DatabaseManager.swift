import SQLite
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()

    private var db: Connection?

    private let usersTable = Table("users")
    private let habitsTable = Table("habits")
    private let completedDaysTable = Table("completedDays")

    private let id = Expression<String>("id")
    private let name = Expression<String>("name")
    private let email = Expression<String>("email")
    private let password = Expression<String>("password")
    private let userId = Expression<String>("userId")
    private let period = Expression<String>("period")
    private let type = Expression<String>("type")
    private let target = Expression<Int>("target")
    private let progress = Expression<Int>("progress")
    private let startDate = Expression<Date>("startDate")
    private let endDate = Expression<Date>("endDate")
    private let achieved = Expression<Bool>("achieved")
    private let date = Expression<Date>("date")

    init() {
        do {
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            db = try Connection(fileUrl.path)
            createTables()
        } catch {
            print("Error initializing database: \(error)")
        }
    }

    private func createTables() {
        do {
            try db?.run(usersTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(email, unique: true)
                table.column(password)
            })

            try db?.run(habitsTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(userId)
                table.column(name)
                table.column(period)
                table.column(type)
                table.column(target)
                table.column(progress)
                table.column(startDate)
                table.column(endDate)
                table.column(achieved)
            })

            try db?.run(completedDaysTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(userId)
                table.column(date)
            })
        } catch {
            print("Error creating tables: \(error)")
        }
    }

    func addUser(_ user: User) {
        do {
            try db?.run(usersTable.insert(
                id <- user.id.uuidString,
                name <- user.name,
                email <- user.email,
                password <- user.password
            ))
            for completedDay in user.completedDays {
                try db?.run(completedDaysTable.insert(
                    id <- UUID().uuidString,
                    self.userId <- user.id.uuidString,
                    self.date <- completedDay
                ))
            }
        } catch {
            print("Error adding user: \(error)")
        }
    }

    func getUser(email: String, password: String) -> User? {
        do {
            if let userRow = try db?.pluck(usersTable.filter(self.email == email && self.password == password)) {
                let completedDays = try db?.prepare(completedDaysTable.filter(self.userId == userRow[self.id])).compactMap { row in
                    row[self.date]
                } ?? []
                let user = User(
                    id: UUID(uuidString: userRow[self.id])!,
                    name: userRow[self.name],
                    email: userRow[self.email],
                    password: userRow[self.password],
                    habits: getHabits(for: userRow[self.id]),
                    completedDays: completedDays
                )
                return user
            }
        } catch {
            print("Error getting user: \(error)")
        }
        return nil
    }

    func addHabit(_ habit: Habit, for userId: String) {
        do {
            try db?.run(habitsTable.insert(
                id <- habit.id.uuidString,
                self.userId <- userId,
                name <- habit.name,
                period <- habit.period,
                type <- habit.type,
                target <- habit.target,
                progress <- habit.progress,
                startDate <- habit.startDate,
                endDate <- habit.endDate,
                achieved <- habit.achieved
            ))
        } catch {
            print("Error adding habit: \(error)")
        }
    }

    func getHabits(for userId: String) -> [Habit] {
        do {
            let habitRows = try db?.prepare(habitsTable.filter(self.userId == userId))
            var habits: [Habit] = []
            habitRows?.forEach { row in
                let habit = Habit(
                    id: UUID(uuidString: row[self.id])!,
                    name: row[self.name],
                    period: row[self.period],
                    type: row[self.type],
                    target: row[self.target],
                    progress: row[self.progress],
                    startDate: row[self.startDate],
                    endDate: row[self.endDate],
                    achieved: row[self.achieved]
                )
                habits.append(habit)
            }
            return habits
        } catch {
            print("Error getting habits: \(error)")
        }
        return []
    }

    func deleteHabit(_ habit: Habit) {
        do {
            try db?.run(habitsTable.filter(id == habit.id.uuidString).delete())
        } catch {
            print("Error deleting habit: \(error)")
        }
    }

    func deleteAllHabits(for userId: String) {
        do {
            try db?.run(habitsTable.filter(self.userId == userId).delete())
        } catch {
            print("Error deleting all habits: \(error)")
        }
    }

    func updateHabitAchieved(_ habit: Habit) {
        do {
            let habitRow = habitsTable.filter(id == habit.id.uuidString)
            try db?.run(habitRow.update(achieved <- habit.achieved))
        } catch {
            print("Error updating habit: \(error)")
        }
    }

    func addCompletedDay(for userId: String, date: Date) {
        do {
            try db?.run(completedDaysTable.insert(
                id <- UUID().uuidString,
                self.userId <- userId,
                self.date <- date
            ))
        } catch {
            print("Error adding completed day: \(error)")
        }
    }

    func getCompletedDays(for userId: String) -> [Date] {
        do {
            let rows = try db?.prepare(completedDaysTable.filter(self.userId == userId))
            var dates: [Date] = []
            rows?.forEach { row in
                dates.append(row[self.date])
            }
            return dates
        } catch {
            print("Error getting completed days: \(error)")
        }
        return []
    }
}






