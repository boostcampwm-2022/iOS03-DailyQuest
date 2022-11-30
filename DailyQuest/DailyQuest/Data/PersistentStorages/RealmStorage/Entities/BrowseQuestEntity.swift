//
//  BrowseQuestEntity.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/15.
//

import Foundation
import RealmSwift

final class BrowseQuestEntity: Object {
    @Persisted var uuid: String
    @Persisted var nickName: String
    @Persisted var profileImageURL: String
    @Persisted var quests: List<SubQuestEntity>

    override init() { }
        
    init(uuid: String, nickName: String, profileImageURL: String, quests: [SubQuestEntity]) {
        self.uuid = uuid
        self.nickName = nickName
        self.profileImageURL = profileImageURL
        let realmList = List<SubQuestEntity>()
        realmList.append(objectsIn: quests)
        self.quests = realmList
    }
    
    override class func primaryKey() -> String? {
        "uuid"
    }
}
