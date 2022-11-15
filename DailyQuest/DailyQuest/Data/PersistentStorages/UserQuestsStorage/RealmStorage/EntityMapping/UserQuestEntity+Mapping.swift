//
//  UserQuestEntity+Mapping.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/14.
//

import Foundation

extension UserQuestEntity {
    convenience init(quest: Quest) {
        self.init(title: quest.title,
                  startDay: quest.startDay,
                  endDay: quest.endDay,
                  currentCount: quest.currentCount,
                  totalCount: quest.totalCount)
    }
}

extension UserQuestEntity {
    func toDomain() -> Quest {
        return Quest(title: title,
                     startDay: startDay,
                     endDay: endDay,
                     repeat: `repeat`,
                     currentCount: currentCount,
                     totalCount: totalCount)
    }
}
