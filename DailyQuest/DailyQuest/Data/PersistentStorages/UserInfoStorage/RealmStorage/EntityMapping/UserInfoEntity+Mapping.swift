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
                  profileURL: user.profileURL,
                  backgroundImageURL: user.backgroundImageURL,
                  introduce: user.introduce,
                  allow: user.allow)
    }
}

// RealmObject -> DomainObject
extension UserInfoEntity {
    func toDomain() -> User {
        return User(uuid: uuid,
                    nickName: nickName,
                    profileURL: profileURL,
                    backgroundImageURL: backgroundImageURL,
                    introduce: introduce,
                    allow: allow)
    }
}
