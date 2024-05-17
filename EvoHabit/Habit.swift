//
//  Habit.swift
//  EvoHabit
//
//  Created by Aubrianna Sample on 5/16/24.
//

import Foundation

struct Habit: Identifiable {
    var id = UUID()
    var name: String
    var period: String
    var type: String
    var target: Int
    var progress: Int
    var startDate: Date
    var endDate: Date
    var achieved: Bool
}




