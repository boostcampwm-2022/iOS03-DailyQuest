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

    var path: String {
        return "users"
    }
}

enum Access: String {
    case quests
    case receiveQuests
    case userInfo

    var path: String {
        return self.rawValue
    }
}

enum CRUD {
    case create
    case read
    case update
    case delete
}

enum NetworkDateFilter {
    case today(_ date: Date)
    case month(_ date: Date)
    case year(_date: Date)
}

enum StoragePath {
    case profileImages
    case backgroundImages
    case another(_ path: String)

    var path: String {
        switch self {
        case .profileImages:
            return "profileImages"
        case .backgroundImages:
            return "backgroundImages"
        case .another(let path):
            return path
        }
    }
}
