//
//  QuestUseCaseMock.swift
//  DailyQuestTests
//
//  Created by jinwoong Kim on 2022/11/21.
//

import Foundation

import RxSwift

final class QuestUseCaseMock: QuestUseCase {
    let quests = [
        Quest.stub(groupId: UUID(),
                   uuid: UUID(),
                   date: Date(),
                   title: "물마시기",
                   currentCount: 0,
                   totalCount: 10),
        Quest.stub(groupId: UUID(),
                   uuid: UUID(),
                   date: Date(),
                   title: "물마시기",
                   currentCount: 0,
                   totalCount: 10),
    ]
    
    func fetch(by date: Date) -> Observable<[Quest]> {
        return Observable.just(quests)
    }
}
