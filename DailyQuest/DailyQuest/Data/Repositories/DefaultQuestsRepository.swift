//
//  DefaultQuestsRepository.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/21.
//

import RxSwift
import Foundation

final class DefaultQuestsRepository {
    private let persistentStorage: QuestsStorage
    private let networkService: NetworkService
    
    init(persistentStorage: QuestsStorage, networkService: NetworkService = FirebaseService.shared) {
        self.persistentStorage = persistentStorage
        self.networkService = networkService
    }
}

extension DefaultQuestsRepository: QuestsRepository {
    func save(with quest: [Quest]) -> Single<[Quest]> {
        return persistentStorage.saveQuests(with: quest)
            .flatMap (saveNetworkService(quests:))
    }
    
    func fetch(by date: Date) -> Single<[Quest]> {
        return persistentStorage.fetchQuests(by: date)
            .catch { [weak self] _ in
                guard let self = self else { return Single.just([]) }
                return self.fetchNetworkService(date: date)
            }
            .catchAndReturn([])
    }
    
    func update(with quest: Quest) -> Single<Quest> {
        return persistentStorage.updateQuest(with: quest)
            .flatMap(updateNetworkService(quest:))
    }
    
    func delete(with questId: UUID) -> Single<Quest> {
        return persistentStorage.deleteQuest(with: questId)
            .flatMap(deleteNetworkService(quest:))
    }
    
    func deleteAll(with groupId: UUID) -> Single<[Quest]> {
        return persistentStorage.deleteQuestGroup(with: groupId)
            .flatMap(deleteAllNetworkService(quests:))
    }
    
    func fetch(by uuid: String, date: Date) -> Single<[Quest]> {
        return networkService.read(type: QuestDTO.self,
                                   userCase: .anotherUser(uuid),
                                   access: .quests,
                                   filter: .today(date))
        .map { $0.toDomain() }
        .toArray()
    }
    
    func fetch(by uuid: String, date: Date, filter: Date) -> Single<[Date: [Quest]]> {
        return networkService.read(type: QuestDTO.self,
                                   userCase: .anotherUser(uuid),
                                   access: .quests,
                                   filter: .month(filter))
            .reduce([Date : [Quest]](), accumulator: ({ dict, questDTO in
                let quest = questDTO.toDomain()
                var dictionary = dict
                
                dictionary[quest.date.startOfDay, default: [Quest]()].append(quest)
                return dictionary
            }))
            .map { dict in
                var dictionary = dict
                date.rangeDaysOfMonth.forEach { date in
                    if dictionary[date] == nil {
                        dictionary[date] = []
                    }
                }
                return dictionary
            }
            .asSingle()
    }
}

private extension DefaultQuestsRepository {
    func saveNetworkService(quests: [Quest]) -> Single<[Quest]> {
        return Observable.from(quests)
            .withUnretained(self)
            .concatMap { (owner, quest) in
                return owner.networkService.create(userCase: .currentUser,
                                                   access: .quests,
                                                   dto: quest.toDTO())
                .map { $0.toDomain() }
                .catchAndReturn(quest)
            }
            .toArray()
    }
    
    func fetchNetworkService(date: Date) -> Single<[Quest]> {
        return networkService.read(type: QuestDTO.self, userCase: .currentUser, access: .quests, filter: .today(date))
            .map { $0.toDomain() }
            .toArray()
            .catchAndReturn([])
    }
    
    func updateNetworkService(quest: Quest) -> Single<Quest> {
        return networkService.update(userCase: .currentUser, access: .quests, dto: quest.toDTO())
            .map { $0.toDomain() }
            .catchAndReturn(quest)
    }
    
    func deleteNetworkService(quest: Quest) -> Single<Quest> {
        return networkService.delete(userCase: .currentUser, access: .quests, dto: quest.toDTO())
            .map { $0.toDomain() }
            .catchAndReturn(quest)
    }
    
    func deleteAllNetworkService(quests: [Quest]) -> Single<[Quest]> {
        Observable.from(quests)
            .concatMap(deleteNetworkService(quest:))
            .toArray()
            .catchAndReturn(quests)
    }
    
}
