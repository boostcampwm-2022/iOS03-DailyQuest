//
//  Quest.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/14.
//

import Foundation

struct Quest {
    let groupId: UUID
    let uuid: UUID
    let date: Date
    let title: String
    var currentCount: Int
    let totalCount: Int
    
    var state: Bool {
        return currentCount == totalCount
    }
    
    /**
     현재 목표달성량(currentCount)에 인자값만큼 더합니다.
     Note. 현재 목표달성량은 전체량(totalCount)를 넘을 수 없습니다.
     
     - Parameters:
        - value: 0보다 큰 정수값입니다. 기본값은 1입니다.
     */
    mutating func increaseCount(with value: Int=1) {
        guard currentCount + value <= totalCount else {
            self.currentCount = totalCount
            return
        }
        self.currentCount += value
    }
    
    /**
     현재 목표달성량(currentCount)에 인자값만큼 뺍니다.
     Note. 현재 목표달성량은 0보다 작을 수 없습니다.
     
     - Parameters:
        - value: 0보다 큰 정수값입니다. 기본값은 1입니다.
     */
    mutating func decreaseCount(with value: Int=1) {
        guard currentCount - value >= 0 else {
            self.currentCount = 0
            return
        }
        self.currentCount -= value
    }
}
