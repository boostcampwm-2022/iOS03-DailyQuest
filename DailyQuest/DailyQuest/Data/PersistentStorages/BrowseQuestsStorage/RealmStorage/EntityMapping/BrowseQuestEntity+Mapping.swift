//
//  BrowseQuestEntity+Mapping.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/15.
//

import Foundation

extension BrowseQuestEntity {
    convenience init(browseQuest: BrowseQuest) {
        self.init(uuid: browseQuest.uuid,
                  nickName: browseQuest.nickName,
                  quest: UserQuestEntity(quest: browseQuest.quest))
    }
}

extension BrowseQuestEntity {
    func toDomain() -> BrowseQuest {
        return BrowseQuest(uuid: uuid,
                           nickName: nickName,
                           quest: quest.toDomain())
    }
}
