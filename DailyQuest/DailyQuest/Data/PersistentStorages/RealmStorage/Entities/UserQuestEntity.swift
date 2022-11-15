//
//  UserQuestEntity.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/14.
//

import Foundation
import RealmSwift

class UserQuestEntity: Object {
    @Persisted var title: String
    @Persisted var startDay: Date
    @Persisted var endDay: Date
    @Persisted var `repeat`: Int
    @Persisted var currentCount: Int
    @Persisted var totalCount: Int
    
    override init(){ }
    
    init(title: String, startDay: Date, endDay: Date, currentCount: Int, totalCount: Int) {
        self.title = title
        self.startDay = startDay
        self.endDay = endDay
        self.currentCount = currentCount
        self.totalCount = totalCount
    }
}
