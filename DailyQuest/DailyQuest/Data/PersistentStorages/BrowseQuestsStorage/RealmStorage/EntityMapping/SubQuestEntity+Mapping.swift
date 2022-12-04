//
//  SubQuestEntity+Mapping.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/30.
//

import Foundation

extension SubQuestEntity {
    convenience init(quest: Quest) {
        self.init(
            groupId: quest.groupId,
            uuid: quest.uuid,
            date: quest.date.toString,
            title: quest.title,
            currentCount: quest.currentCount,
            totalCount: quest.totalCount)
    }
}

extension SubQuestEntity {
    func toDomain() -> Quest {
        return Quest(groupId: groupId,
                     uuid: uuid,
                     date: date.toDate() ?? Date(),
                     title: title,
                     currentCount: currentCount,
                     totalCount: totalCount)
    }
}
