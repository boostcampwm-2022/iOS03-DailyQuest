//
//  DefaultQuestUseCase.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/21.
//

import Foundation

import RxSwift

final class DefaultQuestUseCase {
    private let questsRepository: QuestsRepository
    
    init(questsRepository: QuestsRepository) {
        self.questsRepository = questsRepository
    }
}

extension DefaultQuestUseCase: QuestUseCase {
    func fetch(by date: Date) -> Single<[Quest]> {
        return questsRepository.fetch(by: date)
    }
    
    func update(with quest: Quest) -> Single<Bool> {
        return questsRepository
            .update(with: quest)
            .do(onSuccess: { quest in
                if quest.state {
                    NotificationCenter.default.post(name: .questStateChanged, object: quest.date)
                }
            })
                .map { _ in true }
                .catchAndReturn(false)
    }
    
    func delete(with quest: Quest) -> Single<Bool> {
        return questsRepository
            .delete(with: quest.uuid)
            .do(onSuccess: { quest in
                if quest.state {
                    NotificationCenter.default.post(name: .questStateChanged, object: quest.date)
                }
            })
                .map { _ in true }
                .catchAndReturn(false)
    }
}
