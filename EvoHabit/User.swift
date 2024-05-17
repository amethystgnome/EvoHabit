//
//  User.swift
//  EvoHabit
//
//  Created by Aubrianna Sample on 5/16/24.
//

import Foundation

struct User: Identifiable {
    var id = UUID()
    var name: String
    var email: String
    var password: String
    var habits: [Habit]
}
