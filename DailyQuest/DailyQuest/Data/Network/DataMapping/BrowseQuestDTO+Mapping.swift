//
//  BrowseQuestDTO.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/11/29.
//

import Foundation

struct BrowseQuestDTO {
    let uuid: String
    let nickName: String
    let quests: [QuestDTO]
}

extension BrowseQuestDTO {
    func toDomain() -> BrowseQuest{
        return BrowseQuest(uuid: UUID(uuidString: uuid)!, nickName: nickName, quests: quests.compactMap { $0.toDomain() })
    }
}
