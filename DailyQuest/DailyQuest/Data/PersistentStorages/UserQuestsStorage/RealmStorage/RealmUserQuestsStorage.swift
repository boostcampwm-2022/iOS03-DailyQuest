//
//  RealmUserQuestsStorage.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/14.
//

import Foundation
import RxSwift

final class RealmUserQuestsStorage {

    private let realmStorage: RealmStorage

    init(realmStorage: RealmStorage = RealmStorage.shared) {
        self.realmStorage = realmStorage
    }
}

extension RealmUserQuestsStorage: UserQuestsStorage {
    func fetchUserQuests() -> Observable<[Quest]> {
        return Observable<[Quest]>.create { [weak self] observer in
            guard let realmStorage = self?.realmStorage else {
                return Disposables.create()
            }

            do {
                let quests = try realmStorage.fetchEntities(type: UserQuestEntity.self)
                    .compactMap { $0.toDomain() }
                observer.onNext(quests)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }

    func saveUserQuest(quest: Quest) -> Single<Quest> {
        return Single.create { [weak self] single in
            guard let realmStorage = self?.realmStorage else {
                return Disposables.create()
            }

            let questEntity = UserQuestEntity(quest: quest)

            do {
                try realmStorage.updateEntity(entity: questEntity)
                single(.success(quest))
            } catch let error {
                single(.failure(RealmStorageError.saveError(error)))
            }

            return Disposables.create()
        }
    }
}
