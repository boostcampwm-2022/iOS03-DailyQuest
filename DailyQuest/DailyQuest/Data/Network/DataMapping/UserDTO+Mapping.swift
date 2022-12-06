//
//  UserDTO+Mapping.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/11/29.
//

import Foundation

struct UserDTO: DTO {
    let uuid: String
    let nickName: String
    let profileURL: String
    let backgroundImageURL: String
    let description: String
    let allow: Bool

    init() {
        self.uuid = ""
        self.nickName = ""
        self.profileURL = ""
        self.backgroundImageURL = ""
        self.description = ""
        self.allow = false
    }

    init(user: User) {
        self.uuid = user.uuid
        self.nickName = user.nickName
        self.profileURL = user.profileURL
        self.backgroundImageURL = user.backgroundImageURL
        self.description = user.description
        self.allow = user.allow
    }

    init(uuid: String, userDto: UserDTO) {
        self.uuid = uuid
        self.nickName = userDto.nickName
        self.profileURL = userDto.profileURL
        self.backgroundImageURL = userDto.backgroundImageURL
        self.description = userDto.description
        self.allow = userDto.allow
    }
}

extension UserDTO {
    func toDomain() -> User {
        User(uuid: uuid,
             nickName: nickName,
             profileURL: profileURL,
             backgroundImageURL: backgroundImageURL,
             description: description,
             allow: allow)
    }
}

extension User {
    func toDTO() -> UserDTO {
        UserDTO(user: self)
    }
}
