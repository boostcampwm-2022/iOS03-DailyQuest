//
//  QuestDTO+Mapping.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/11/21.
//

import Foundation

struct QuestDTO: DTO {
    let uuid: UUID
    let title: String
    let currentCount: Int
    let totalCount: Int
    let groupUid: UUID
}

extension QuestDTO {
    func toDomain() -> Quest {
        return Quest(groupId: groupUid,
                     uuid: uuid,
                     title: title,
                     currentCount: currentCount,
                     totalCount: totalCount)
    }
}
