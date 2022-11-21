//
//  BrowseQuestEntity+Mapping.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/15.
//

import Foundation

extension BrowseQuestEntity {
    convenience init(browseQuest: BrowseQuest) {
        let questsEntities = browseQuest.quests.compactMap { QuestEntity(quest: $0) }
        
        self.init(uuid: browseQuest.uuid,
                  nickName: browseQuest.nickName,
                  quests: questsEntities)
    }
}

extension BrowseQuestEntity {
    func toDomain() -> BrowseQuest {
        let quests = Array(quests).compactMap { $0.toDomain() }
        return BrowseQuest(uuid: uuid,
                           nickName: nickName,
                           quests: quests)
    }
}
