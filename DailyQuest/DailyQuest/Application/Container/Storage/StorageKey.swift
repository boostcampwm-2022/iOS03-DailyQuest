//
//  StorageKey.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/12.
//

import Foundation
import DailyContainer

struct QuestStorageKey: InjectionKey {
    typealias Value = QuestsStorage
}

struct BrowseQuestStorageKey: InjectionKey {
    typealias Value = BrowseQuestsStorage
}

struct UserInfoStorageKey: InjectionKey {
    typealias Value = UserInfoStorage
}
