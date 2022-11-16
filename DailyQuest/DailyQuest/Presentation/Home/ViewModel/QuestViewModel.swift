//
//  QuestViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import Foundation

import RxSwift

final class QuestViewModel {
    let quests = [
        Quest(uuid: UUID(), title: "물마시기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 4, totalCount: 5),
        Quest(uuid: UUID(), title: "책읽기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 9, totalCount: 20),
        Quest(uuid: UUID(), title: "달리기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 4, totalCount: 9),
        Quest(uuid: UUID(), title: "잠자기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 1, totalCount: 1)
    ]
    
    let data: Observable<[Quest]>
    
    init() {
        self.data = .just(quests)
    }
}
