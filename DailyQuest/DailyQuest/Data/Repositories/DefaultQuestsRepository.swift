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
            .flatMap { quests in
            return Observable.from(quests)
                .concatMap { quest in
                return self.networkService.create(userCase: .currentUser,
                                                  access: .quests,
                                                  dto: quest.toDTO())
            }
                .map { $0.toDomain() }
                .toArray()
                .asObservable()
                .asSingle()
        }
    }

    func fetch(by date: Date) -> Observable<[Quest]> {
        return persistentStorage.fetchQuests(by: date)
            .catch { _ in
            self.networkService.read(type: QuestDTO.self, userCase: .currentUser, access: .quests, filter: .today(date))
                .map { $0.toDomain() }
                .toArray()
                .asObservable()
        }
    }

    func update(with quest: Quest) -> Single<Quest> {
        return persistentStorage.updateQuest(with: quest)
            .flatMap { quest in
            self.networkService.update(userCase: .currentUser, access: .quests, dto: quest.toDTO())
        }
            .map { $0.toDomain() }
            .asObservable()
            .asSingle()
    }

    func delete(with questId: UUID) -> Single<Quest> {
        return persistentStorage.deleteQuest(with: questId)
            .flatMap { quest in
            self.networkService.delete(userCase: .currentUser, access: .quests, dto: quest.toDTO())
        }
            .map { $0.toDomain() }
            .asObservable()
            .asSingle()
    }

    func deleteAll(with groupId: UUID) -> Single<[Quest]> {
        return persistentStorage.deleteQuestGroup(with: groupId)
            .flatMap { quests in
            return Observable.from(quests)
                .concatMap { quest in
                self.networkService.delete(userCase: .currentUser,
                                           access: .quests,
                                           dto: quest.toDTO())
            }
                .map { $0.toDomain() }
                .toArray()
                .asObservable()
                .asSingle()
        }
    }

    func fetch(by uuid: String, date: Date) -> Observable<[Quest]> { // 받을 날짜까지 받아와야함
        return self.networkService.read(type: QuestDTO.self,
                                        userCase: .anotherUser(uuid),
                                        access: .quests,
                                        filter: .today(date))
            .map { $0.toDomain() }
            .toArray()
            .asObservable()
    }
}
