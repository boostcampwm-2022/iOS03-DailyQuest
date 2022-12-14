//
//  DefaultFriendQuestUseCase.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/08.
//

import Foundation

import RxSwift

final class DefaultFriendUseCase {
    private let questsRepository: QuestsRepository
    
    init(questsRepository: QuestsRepository) {
        self.questsRepository = questsRepository
    }
}

extension DefaultFriendUseCase: FriendQuestUseCase {
    func fetch(with uuid: String, by date: Date) -> Single<[Quest]> {
        return questsRepository.fetch(by: uuid, date: date)
    }
}
