//
//  BrowseQuest+Stub.swift
//  DailyQuestTests
//
//  Created by jinwoong Kim on 2022/11/29.
//

import Foundation

extension BrowseQuest {
    static func stub(user: User, quests: [Quest]) -> Self {
        return .init(user: user, quests: quests)
    }
}
