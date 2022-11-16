//
//  BrowseCellItemModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/15.
//

import Foundation

final class BrowseItemViewModel {
    let user: User
    let quests: [Quest]
    
    init(user: User, quests: [Quest]) {
        self.user = user
        self.quests = quests
    }
}
