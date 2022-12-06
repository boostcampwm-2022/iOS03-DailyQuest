//
//  DefaultEnrollUseCase.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/05.
//

import Foundation

import RxSwift

final class DefaultEnrollUseCase {
    private let questsRepository: QuestsRepository
    
    init(questsRepository: QuestsRepository) {
        self.questsRepository = questsRepository
    }
}

extension DefaultEnrollUseCase: EnrollUseCase {
    func save(with quests: [Quest]) -> Observable<Bool> {
        return questsRepository
            .save(with: quests)
            .map { _ in
                true
            }
            .catchAndReturn(false)
            .do(onSuccess: { _ in
                let today = quests
                    .filter { quest in
                        Calendar.current.isDateInToday(quest.date)
                    }
                if !today.isEmpty {
                    NotificationCenter.default.post(name: .updated, object: Date())
                }
            })
            .asObservable()
    }
}
