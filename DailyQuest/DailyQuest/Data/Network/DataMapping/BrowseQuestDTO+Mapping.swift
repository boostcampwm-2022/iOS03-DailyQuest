//
//  BrowseQuestDTO.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/11/29.
//

import Foundation

struct BrowseQuestDTO {
    let user: UserDTO
    let quests: [QuestDTO]

    init() {
        self.user = UserDTO()
        self.quests = [QuestDTO()]
    }
}

extension BrowseQuestDTO {
    func toDomain() -> BrowseQuest {
        return BrowseQuest(user: user.toDomain(), quests: quests.compactMap { $0.toDomain() })
    }
}
