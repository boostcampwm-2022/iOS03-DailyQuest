//
//  QuestEntity+Mapping.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/14.
//

import Foundation

extension QuestEntity {
    convenience init(quest: Quest) { // Quest에 date 들어가면 수정
        self.init(
            groupId: quest.groupId,
            uuid: quest.uuid,
            date: quest.date.toString,
            title: quest.title,
            currentCount: quest.currentCount,
            totalCount: quest.totalCount)
    }
}

extension QuestEntity {
    func toDomain() -> Quest {
        return Quest(groupId: groupId,
                     uuid: uuid,
                     date: date.toDate() ?? Date(),
                     title: title,
                     currentCount: currentCount,
                     totalCount: totalCount)
    }
}
