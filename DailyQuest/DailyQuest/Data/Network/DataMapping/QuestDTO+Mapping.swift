//
//  QuestDTO+Mapping.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/11/21.
//

import Foundation

struct QuestDTO: DTO {
    let groupId: UUID
    let uuid: String
    let date: String
    let title: String
    let currentCount: Int
    let totalCount: Int

}

extension QuestDTO {
    func toDomain() -> Quest {
        return Quest(groupId: groupId,
                     uuid: UUID(uuidString: uuid)!,
                     date: date.toDate()!,
                     title: title,
                     currentCount: currentCount,
                     totalCount: totalCount)
    }
}
