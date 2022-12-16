//
//  UseCaseKey.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/12.
//

import Foundation

import DailyContainer

// MARK: - Home Scene
struct QuestUseCaseKey: InjectionKey {
    typealias Value = QuestUseCase
}

struct EnrollUseCaseKey: InjectionKey {
    typealias Value = EnrollUseCase
}

struct UserUseCaseKey: InjectionKey {
    typealias Value = UserUseCase
}

struct CalendarUseCaseKey: InjectionKey {
    typealias Value = CalendarUseCase
}

// MARK: - Browse Scene
struct BrowseUseCaseKey: InjectionKey {
    typealias Value = BrowseUseCase
}

struct FriendQuestUseCaseKey: InjectionKey {
    typealias Value = FriendQuestUseCase
}

struct FriendCalendarUseCaseKey: InjectionKey {
    typealias Value = CalendarUseCase
}

// MARK: - Settings Scene
struct AuthUseCaseKey: InjectionKey {
    typealias Value = AuthUseCase
}

struct SettingsUseCaseKey: InjectionKey {
    typealias Value = SettingsUseCase
}
