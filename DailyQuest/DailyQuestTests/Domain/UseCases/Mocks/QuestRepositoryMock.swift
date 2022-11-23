//
//  QuestRepositoryMock.swift
//  DailyQuestTests
//
//  Created by jinwoong Kim on 2022/11/21.
//

import Foundation

import RxSwift

final class QuestRepositoryMock: QuestsRepository {
    let quests = [
        Quest.stub(groupId: UUID(),
                   uuid: UUID(),
                   title: "물마시기",
                   currentCount: 0,
                   totalCount: 10),
        Quest.stub(groupId: UUID(),
                   uuid: UUID(),
                   title: "물마시기",
                   currentCount: 0,
                   totalCount: 10),
    ]
    
    func save(with quest: [Quest]) -> Single<[Quest]> {
        
        return Single.just([])
    }

    func update(with quest: Quest) -> Single<Quest> {
        return Single.just(quests[0])
    }
    
    func delete(with questId: UUID) -> Single<Quest> {
        return Single.just(quests[0])
    }
    
    func deleteAll(with groupId: UUID) -> Single<[Quest]> {
        return Single.just(quests)
    }
    
    func fetch(by date: Date) -> Observable<[Quest]> {
        return Observable.just(quests)
    }
}
