//
//  RealmQuestsStorage.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/14.
//

import Foundation
import RxSwift

final class RealmQuestsStorage {

    private let realmStorage: RealmStorage

    init(realmStorage: RealmStorage = RealmStorage.shared) {
        self.realmStorage = realmStorage
    }
}

extension RealmQuestsStorage: QuestsStorage {
    func saveQuests(with quests: [Quest]) -> Single<[Quest]> {
        return Single.create { [weak self] single in
            guard let realmStorage = self?.realmStorage else {
                return Disposables.create()
            }

            do {
                for quest in quests {
                    let questEntity = QuestEntity(quest: quest)
                    try realmStorage.saveEntity(entity: questEntity)
                }
                single(.success(quests))
            } catch let error {
                single(.failure(RealmStorageError.saveError(error)))

            }
            return Disposables.create()
        }
    }

    func fetchQuests(by date: Date) -> Observable<[Quest]> {
        return Observable<[Quest]>.create { [weak self] observer in
            guard let realmStorage = self?.realmStorage else {
                return Disposables.create()
            }

            do {
                let quests = try realmStorage
                    .fetchEntities(type: QuestEntity.self, filter: NSPredicate(format: "date == %@", date.toString))
                    .compactMap { $0.toDomain() }
                observer.onNext(quests)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }

    func updateQuest(with quest: Quest) -> Single<Quest> {
        return Single.create { [weak self] single in
            guard let realmStorage = self?.realmStorage else {
                return Disposables.create()
            }
            let questEntity = QuestEntity(quest: quest)
            do {
                try realmStorage.updateEntity(entity: questEntity)
                single(.success(quest))
            } catch let error {
                print(#function)
                print(error)
                single(.failure(RealmStorageError.saveError(error)))
            }

            return Disposables.create()
        }
    }

    func deleteQuest(with questId: UUID) -> Single<Quest> {
        return Single.create { [weak self] single in
            guard let realmStorage = self?.realmStorage else {
                return Disposables.create()
            }

            do {
                guard let entity = try realmStorage.findEntities(type: QuestEntity.self, filter: NSPredicate(format: "uuid == %@", questId as CVarArg)).first else {
                    throw RealmStorageError.noDataError
                }
                let quest = entity.toDomain()
                try realmStorage.deleteEntity(entity: entity)
                single(.success(quest))

            } catch let error {
                single(.failure(RealmStorageError.deleteError(error)))
            }

            return Disposables.create()
        }

    }

    func deleteQuestGroup(with groupId: UUID) -> Single<[Quest]> {
        return Single.create { [weak self] single in
            guard let realmStorage = self?.realmStorage else {
                return Disposables.create()
            }

            do {
                let entities = try realmStorage.findEntities(type: QuestEntity.self, filter: NSPredicate(format: "groupId == %@", groupId as CVarArg))
                let quests = entities.compactMap { $0.toDomain() }
                for entity in entities {
                    try realmStorage.deleteEntity(entity: entity)
                }
                single(.success(quests))

            } catch let error {
                single(.failure(RealmStorageError.deleteError(error)))
            }

            return Disposables.create()
        }
    }

    func deleteAllQuests() -> Single<[Quest]> {
        return Single.create { [weak self] single in
            guard let realmStorage = self?.realmStorage else {
                return Disposables.create()
            }
            do {
                let entities = try realmStorage.fetchEntities(type: QuestEntity.self)
                let quests = entities.compactMap { $0.toDomain() }
                for entity in entities {
                    try realmStorage.deleteEntity(entity: entity)
                }
                single(.success(quests))
                
            } catch let error {
                single(.failure(RealmStorageError.deleteError(error)))
            }

            return Disposables.create()
        }
    }
}
