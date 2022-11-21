//
//  UserQuestEntity+Mapping.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/14.
//

import Foundation

extension UserQuestEntity {
    convenience init(quest: Quest) {
        self.init(uuid: quest.uuid,
                  title: quest.title,
                  startDay: Date(), // no more use
                  endDay: Date(), // no more use
                  currentCount: quest.currentCount,
                  totalCount: quest.totalCount)
    }
}

extension UserQuestEntity {
    func toDomain() -> Quest {
        return Quest(groupId: UUID(), // update here
                     uuid: uuid,
                     title: title,
                     currentCount: currentCount,
                     totalCount: totalCount)
    }
}
