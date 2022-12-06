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
    let description: String
    let allow: Bool
    
    init(){
        self.uuid = ""
        self.nickName = ""
        self.profileURL = ""
        self.backgroundImageURL = ""
        self.description = ""
        self.allow = false
    }
    
    init(uuid: String, nickName: String, profileURL: String, backgroundImageURL: String, description: String, allow: Bool) {
        self.uuid = uuid
        self.nickName = nickName
        self.profileURL = profileURL
        self.backgroundImageURL = backgroundImageURL
        self.description = description
        self.allow = allow
    }
    
    
}
