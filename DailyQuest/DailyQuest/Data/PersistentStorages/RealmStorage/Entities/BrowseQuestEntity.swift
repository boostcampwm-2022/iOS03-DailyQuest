//
//  BrowseQuestEntity.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/15.
//

import Foundation
import RealmSwift

final class BrowseQuestEntity: Object {
    @Persisted var uuid: UUID
    @Persisted var nickName: String
    @Persisted var quests: List<QuestEntity>

    override init() { }
        
    init(uuid: UUID, nickName: String, quests: [QuestEntity]) {
        self.uuid = uuid
        self.nickName = nickName
        let realmList = List<QuestEntity>()
        realmList.append(objectsIn: quests)
        self.quests = realmList
    }
    
    override class func primaryKey() -> String? {
        "uuid"
    }
}
