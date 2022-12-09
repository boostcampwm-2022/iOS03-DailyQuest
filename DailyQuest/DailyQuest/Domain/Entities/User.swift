//
//  User.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/14.
//

import Foundation

struct User {
    let uuid: String
    let nickName: String
    let profileURL: String
    let backgroundImageURL: String
    let introduce: String
    let allow: Bool

    init() {
        self.uuid = ""
        self.nickName = ""
        self.profileURL = ""
        self.backgroundImageURL = ""
        self.introduce = ""
        self.allow = false
    }

    init(nickName: String) {
        self.uuid = ""
        self.nickName = nickName
        self.profileURL = ""
        self.backgroundImageURL = ""
        self.introduce = ""
        self.allow = true
    }

    init(uuid: String, nickName: String, profileURL: String, backgroundImageURL: String, introduce: String, allow: Bool) {
        self.uuid = uuid
        self.nickName = nickName
        self.profileURL = profileURL
        self.backgroundImageURL = backgroundImageURL
        self.introduce = introduce
        self.allow = allow
    }
}

extension User {
    func setProfileImageURL(profileURL: String) -> User {
        return User(uuid: self.uuid,
                    nickName: self.nickName,
                    profileURL: profileURL,
                    backgroundImageURL: self.backgroundImageURL,
                    introduce: self.introduce,
                    allow: self.allow)
    }

    func setBackgroundImageURL(backgroundImageURL: String) -> User {
        return User(uuid: self.uuid,
                    nickName: self.nickName,
                    profileURL: self.profileURL,
                    backgroundImageURL: backgroundImageURL,
                    introduce: self.introduce,
                    allow: self.allow)
    }
}
