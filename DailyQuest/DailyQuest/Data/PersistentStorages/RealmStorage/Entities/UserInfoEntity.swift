//
//  UserInfoEntity.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/15.
//

import Foundation
import RealmSwift

final class UserInfoEntity: Object {
    @Persisted var uuid: UUID
    @Persisted var nickName: String
    @Persisted var profile: Data
    @Persisted var backgroundImage: Data
    @Persisted var userDescription: String

    override init() { }

    init(uuid: UUID, nickName: String, profile: Data, backgroundImage: Data, description: String) {
        self.uuid = uuid
        self.nickName = nickName
        self.profile = profile
        self.backgroundImage = backgroundImage
        self.userDescription = description
    }
}
