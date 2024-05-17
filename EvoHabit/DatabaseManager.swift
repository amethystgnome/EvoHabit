//
//  DatabaseManager.swift
//  EvoHabit
//
//  Created by Aubrianna Sample on 5/16/24.
//

import SQLite
import SwiftUI

class DatabaseManager {
    static let shared = DatabaseManager()

    private var db: Connection?

    private let usersTable = Table("users")
    private let habitsTable = Table("habits")

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
        } catch {
            print("Error adding user: \(error)")
        }
    }

    func getUser(email: String, password: String) -> User? {
        do {
            if let userRow = try db?.pluck(usersTable.filter(self.email == email && self.password == password)) {
                let user = User(
                    id: UUID(uuidString: userRow[self.id])!,
                    name: userRow[self.name],
                    email: userRow[self.email],
                    password: userRow[self.password],
                    habits: getHabits(for: userRow[self.id])
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
}



