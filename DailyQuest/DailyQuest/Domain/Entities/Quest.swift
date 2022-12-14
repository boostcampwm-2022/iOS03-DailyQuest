//
//  Quest.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/14.
//

import Foundation

struct Quest: Equatable {
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
    //    mutating func increaseCount(with value: Int=1) {
    //        guard currentCount + value <= totalCount else {
    //            self.currentCount = totalCount
    //            return
    //        }
    //        self.currentCount += value
    //    }
    func increaseCount(with value: Int=1) -> Self? {
        guard currentCount + value <= totalCount else {
            return nil
        }
        return .init(groupId: groupId, uuid: uuid, date: date, title: title, currentCount: currentCount+value, totalCount: totalCount)
    }
    
    /**
     현재 목표달성량(currentCount)에 인자값만큼 뺍니다.
     Note. 현재 목표달성량은 0보다 작을 수 없습니다.
     
     - Parameters:
     - value: 0보다 큰 정수값입니다. 기본값은 1입니다.
     */
    func decreaseCount(with value: Int=1) -> Self? {
        guard currentCount - value >= 0 else {
            return nil
        }
        return .init(groupId: groupId, uuid: uuid, date: date, title: title, currentCount: currentCount-value, totalCount: totalCount)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.groupId == rhs.groupId &&
        lhs.uuid == rhs.uuid &&
        lhs.date == rhs.date &&
        lhs.title == rhs.title &&
        lhs.currentCount == rhs.currentCount &&
        lhs.totalCount == rhs.totalCount
    }
    
}
