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

// MARK: - Settings Scene
