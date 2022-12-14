//
//  UserQuestEntity.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/14.
//

import Foundation
import RealmSwift

final class QuestEntity: Object {
    @Persisted var groupId: UUID
    @Persisted var uuid: UUID
    @Persisted var date: String
    @Persisted var title: String
    @Persisted var currentCount: Int
    @Persisted var totalCount: Int

    override init() { }

    init(groupId: UUID, uuid: UUID, date: String, title: String, currentCount: Int, totalCount: Int) {
        self.groupId = groupId
        self.uuid = uuid
        self.date = date
        self.title = title
        self.currentCount = currentCount
        self.totalCount = totalCount
    }

    override class func primaryKey() -> String? {
        "uuid"
    }
}
