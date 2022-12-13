//
//  RepositoryKey.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/12.
//

import Foundation
import DailyContainer

struct QuestRepositoryKey: InjectionKey {
    typealias Value = QuestsRepository
}

struct AuthRepositoryKey: InjectionKey {
    typealias Value = AuthRepository
}

struct BrowseRepositoryKey: InjectionKey {
    typealias Value = BrowseRepository
}

struct UserRepositoryKey: InjectionKey {
    typealias Value = UserRepository
}

struct ProtectedUserRepositoryKey: InjectionKey {
    typealias Value = ProtectedUserRepository
}
