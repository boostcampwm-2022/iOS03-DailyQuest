//
//  Quest.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/14.
//

import Foundation

struct Quest {
    let uuid: UUID
    let title: String
    let startDay: Date
    let endDay: Date
    let `repeat`: Int
    var currentCount: Int
    let totalCount: Int
    
    var state: Bool {
        return currentCount == totalCount
    }
    
    mutating func increaseCount(with value: Int=1) {
        guard currentCount + value <= totalCount else {
            self.currentCount = totalCount
            return
        }
        self.currentCount += value
    }
    
    mutating func decreaseCount(with value: Int=1) {
        guard currentCount - value >= 0 else {
            self.currentCount = 0
            return
        }
        self.currentCount -= value
    }
}
