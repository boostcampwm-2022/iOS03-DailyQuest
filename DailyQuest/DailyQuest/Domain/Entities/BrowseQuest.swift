//
//  BrowseQuest.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/15.
//

import Foundation

// Domain-Entities 이동
struct BrowseQuest {
    let user: User
    let quests: [Quest]
}
