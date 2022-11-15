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
    @Persisted var quest: UserQuestEntity

    override init() { }
        
    init(uuid: UUID, nickName: String, quest: UserQuestEntity) {
        self.uuid = uuid
        self.nickName = nickName
        self.quest = quest
    }
    
    override class func primaryKey() -> String? {
        "uuid"
    }
}
