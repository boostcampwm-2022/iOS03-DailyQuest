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
}

extension UserDTO {
    func toDomian() -> User {
        User(uuid: uuid,
             nickName: nickName,
             profileURL: profileURL,
             backgroundImageURL: backgroundImageURL,
             description: description,
             allow: allow)
    }
}
