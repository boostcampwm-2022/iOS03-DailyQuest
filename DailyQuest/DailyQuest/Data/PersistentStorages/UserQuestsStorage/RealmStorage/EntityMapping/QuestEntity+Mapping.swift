//
//  QuestEntity+Mapping.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/14.
//

import Foundation

extension QuestEntity {
    convenience init(quest: Quest) {
        self.init(uuid: quest.uuid,
                  title: quest.title,
                  currentCount: quest.currentCount,
                  totalCount: quest.totalCount)
    }
}

extension QuestEntity {
    func toDomain() -> Quest {
        return Quest(groupId: UUID(), // update here
                     uuid: uuid,
                     title: title,
                     currentCount: currentCount,
                     totalCount: totalCount)
    }
}
