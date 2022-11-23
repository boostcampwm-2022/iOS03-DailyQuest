//
//  NetworkConfigure.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/17.
//

import Foundation

enum UserCase {
    case currentUser
    case anotherUser(_ uid: String)
}

enum Access {
    case quests
    case receiveQuests
    case userInfo
}

enum CRUD {
    case create
    case read
    case update
    case delete
}

enum NetworkCondition {
    case today(_ date: Date)
    case month(_ date: Date)
    case year(_date: Date)
}
