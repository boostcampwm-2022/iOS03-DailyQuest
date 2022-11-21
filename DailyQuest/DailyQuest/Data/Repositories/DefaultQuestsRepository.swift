//
//  DefaultQuestsRepository.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/21.
//

import RxSwift
import Foundation

final class DefaultQuestsRepository {
    
    private let persistentStorage: UserQuestsStorage
    
    init(persistentStorage: UserQuestsStorage){
        self.persistentStorage = persistentStorage
    }
}

extension DefaultQuestsRepository: QuestsRepository {
    func save(with quest: [Quest]) -> Single<[Quest]> {
        return persistentStorage.saveQuests(with: quest)
    }
    
    func fetch(by date: Date) -> Observable<[Quest]> {
        return persistentStorage.fetchQuests(by: date)
    }
    
    func update(with quest: Quest) -> Single<Quest> {
        return persistentStorage.updateQuest(with: quest)
    }
    
    func delete(with questId: UUID) -> Single<Quest> {
        return persistentStorage.deleteQuest(with: questId)
    }
    
    func deleteAll(with groupId: UUID) -> Single<[Quest]> {
        return persistentStorage.deleteQuestGroup(with: groupId)
    }
    
    
}
