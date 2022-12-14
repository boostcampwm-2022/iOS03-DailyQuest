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

    init() {
        self.groupId = UUID()
        self.uuid = ""
        self.date = ""
        self.title = ""
        self.currentCount = 0
        self.totalCount = 0
    }
    
    init(groupId: UUID, uuid: String, date: String, title: String, currentCount: Int, totalCount: Int) {
        self.groupId = groupId
        self.uuid = uuid
        self.date = date
        self.title = title
        self.currentCount = currentCount
        self.totalCount = totalCount
    }
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

extension Quest {
    func toDTO() -> QuestDTO {
        return QuestDTO(groupId: groupId,
                        uuid: uuid.uuidString,
                        date: date.toString,
                        title: title,
                        currentCount: currentCount,
                        totalCount: totalCount)
    }
}
