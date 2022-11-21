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
    func fetch(by date: Date) -> Observable<[Quest]> {
        return questsRepository.fetch(by: date)
    }
}