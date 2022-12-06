//
//  MonthlyQuestCompletion.swift
//  DailyQuest
//
//  Created by wickedRun on 2022/12/06.
//

import Foundation

struct MonthlyQuestCompletion {
    
    let month: Date
    let states: [DailyQuestCompletion]
}

extension MonthlyQuestCompletion: Comparable {
    
    static func < (lhs: MonthlyQuestCompletion, rhs: MonthlyQuestCompletion) -> Bool {
        return lhs.month < rhs.month
    }
}

extension MonthlyQuestCompletion: Equatable {
    
    static func == (lhs: MonthlyQuestCompletion, rhs: MonthlyQuestCompletion) -> Bool {
        return lhs.month == rhs.month
    }
}
