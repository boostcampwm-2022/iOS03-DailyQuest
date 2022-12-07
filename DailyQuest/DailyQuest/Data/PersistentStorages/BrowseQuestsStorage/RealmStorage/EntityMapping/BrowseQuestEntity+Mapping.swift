//
//  BrowseQuestEntity+Mapping.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/15.
//

import Foundation

extension BrowseQuestEntity {
    convenience init(browseQuest: BrowseQuest) {
        let questsEntities = browseQuest.quests.compactMap { SubQuestEntity(quest: $0) }
        
        self.init(uuid: browseQuest.user.uuid, nickName: browseQuest.user.nickName, profileImageURL: browseQuest.user.profileURL, quests: questsEntities)
    }
}

extension BrowseQuestEntity {
    func toDomain() -> BrowseQuest {
        let quests = Array(quests).compactMap { $0.toDomain() }
        return BrowseQuest(user: User(uuid: uuid,
                                      nickName: nickName,
                                      profileURL: profileImageURL,
                                      backgroundImageURL: "",
                                      introduce: "",
                                      allow: false),
                           quests: quests)
    }
}
