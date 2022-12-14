//
//  RealmBrowseQuestsStorage.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/15.
//

import RxSwift

final class RealmBrowseQuestsStorage {

    private let realmStorage: RealmStorage

    init(realmStorage: RealmStorage = RealmStorage.shared) {
        self.realmStorage = realmStorage
    }
}

extension RealmBrowseQuestsStorage: BrowseQuestsStorage {
    func fetchBrowseQuests() -> Single<[BrowseQuest]> {
        return Single<[BrowseQuest]>.create { [weak self] single in
            guard let realmStorage = self?.realmStorage else {
                return Disposables.create()
            }

            do {
                let browseQuests = try realmStorage.readEntities(type: BrowseQuestEntity.self)
                    .compactMap { $0.toDomain() }
                single(.success(browseQuests))
            } catch let error {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    func saveBrowseQuest(browseQuest: BrowseQuest) -> Single<BrowseQuest> {
        return Single.create { [weak self] single in
            guard let realmStorage = self?.realmStorage else {
                return Disposables.create()
            }

            let browseQuestEntity = BrowseQuestEntity(browseQuest: browseQuest)

            do {
                try realmStorage.createEntity(entity: browseQuestEntity)
                single(.success(browseQuest))
            } catch let error {
                single(.failure(RealmStorageError.saveError(error)))
            }

            return Disposables.create()
        }
    }

    func deleteBrowseQuests() -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let realmStorage = self?.realmStorage else {
                return Disposables.create()
            }

            do {
                try realmStorage.deleteAllEntity(type: BrowseQuestEntity.self)
                try realmStorage.deleteAllEntity(type: SubQuestEntity.self)
                single(.success(true))
            } catch let error {
                single(.failure(RealmStorageError.deleteError(error)))
            }

            return Disposables.create()
        }
    }

}
