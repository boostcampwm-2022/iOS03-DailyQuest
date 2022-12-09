//
//  RealmUserInfoStorage.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/15.
//

import RxSwift

final class RealmUserInfoStorage {

    private let realmStorage: RealmStorage

    init(realmStorage: RealmStorage = RealmStorage.shared) {
        self.realmStorage = realmStorage
    }
}

extension RealmUserInfoStorage: UserInfoStorage {
    func fetchUserInfo() -> Single<User> {
        return Single<User>.create { [weak self] single in
            do {
                guard let realmStorage = self?.realmStorage else { throw RealmStorageError.realmObjectError }
                guard let userInfoEntity = try realmStorage.fetchEntities(type: UserInfoEntity.self)
                    .first else {
                    throw RealmStorageError.noDataError
                }
                single(.success(userInfoEntity.toDomain()))
            } catch let error {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }

    func updateUserInfo(user: User) -> Single<User> {
        return Single.create { [weak self] single in
            let userInfo = UserInfoEntity(user: user)
            do {
                guard let realmStorage = self?.realmStorage else { throw RealmStorageError.realmObjectError }
                // update 성공했을 경우, success(user)
                try realmStorage.updateEntity(entity: userInfo)
                single(.success(user))
            } catch let error {
                // update 성공하지 못했을 경우, failure(error)
                single(.failure(RealmStorageError.saveError(error)))
            }

            return Disposables.create()
        }
    }

    func deleteUserInfo() -> Single<User> {
        return Single.create { [weak self] single in
            do {
                guard let realmStorage = self?.realmStorage else { throw RealmStorageError.realmObjectError }
                guard let user = try realmStorage.deleteAllEntity(type: UserInfoEntity.self).first?.toDomain() else {
                    throw RealmStorageError.noDataError
                }
                single(.success(user))
            } catch let error {
                // update 성공하지 못했을 경우, failure(error)
                single(.failure(RealmStorageError.deleteError(error)))
            }
            return Disposables.create()
        }
    }

}
