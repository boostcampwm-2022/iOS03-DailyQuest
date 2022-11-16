//
//  UserInfoEntity+Mapping.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/15.
//

import Foundation

// DomainObject -> RealmObject
extension UserInfoEntity {
    convenience init(user: User) {
        self.init(uuid: user.uuid,
                  nickName: user.nickName,
                  profile: user.profile,
                  backgroundImage: user.backgroundImage,
                  description: user.description)
    }
}

// RealmObject -> DomainObject
extension UserInfoEntity {
    func toDomain() -> User {
        return User(uuid: uuid,
                    nickName: nickName,
                    profile: profile,
                    backgroundImage: backgroundImage,
                    description: description)
    }
}
