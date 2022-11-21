//
//  UserQuestEntity.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/14.
//

import Foundation
import RealmSwift

final class UserQuestEntity: Object {
    @Persisted var groupId: UUID
    @Persisted var uuid: UUID
    @Persisted var title: String
    @Persisted var currentCount: Int
    @Persisted var totalCount: Int

    override init() { }

    init(uuid: UUID, title: String, currentCount: Int, totalCount: Int) {
        self.uuid = uuid
        self.title = title
        self.currentCount = currentCount
        self.totalCount = totalCount
    }
    
    override class func primaryKey() -> String? {
        "uuid"
    }
}
