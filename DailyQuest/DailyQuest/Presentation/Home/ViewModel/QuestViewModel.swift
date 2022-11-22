//
//  QuestViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import Foundation

import RxSwift

final class QuestViewModel {
    private let questUseCase: QuestUseCase
    
//    let quests = [
//       Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "물마시기", currentCount: 4, totalCount: 5),
//       Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "책읽기", currentCount: 9, totalCount: 20),
//       Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "달리기", currentCount: 4, totalCount: 9),
//       Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "잠자기", currentCount: 1, totalCount: 1)
//    ]
    
    init(questUseCase: QuestUseCase) {
        self.questUseCase = questUseCase
    }
}
