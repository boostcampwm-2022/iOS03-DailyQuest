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
    func fetchUserInfo() -> Observable<User> {
        return Observable<User>.create { [weak self] observer in
            guard let realmStorage = self?.realmStorage else {
                // self가 존재하지 않을 경우, 반환하지 않고 종료
                return Disposables.create()
            }

            do {
                guard let userInfoEntity = try realmStorage.fetchEntities(type: UserInfoEntity.self)
                    .first else {
                    throw RealmStorageError.noDataError
                }

                observer.onNext(userInfoEntity.toDomain())
                observer.onCompleted()
            } catch let error {
                // Realm을 불러올 수 없을 경우, realmObjectError
                // User 정보가 없을 경우, noDataError
                observer.onError(error)
            }

            return Disposables.create()
        }
    }

    func updateUserInfo(user: User) -> Single<User> {
        return Single.create { [weak self] single in
            guard let realmStorage = self?.realmStorage else {
                return Disposables.create()
            }

            let userInfo = UserInfoEntity(user: user)

            do {
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
            guard let realmStorage = self?.realmStorage else {
                return Disposables.create()
            }

            do {
                // update 성공했을 경우, success(user)
                guard let user = try realmStorage.deleteAllEntity(type: UserInfoEntity.self).first?.toDomain() else {
                    throw RealmStorageError.noDataError
                }
                single(.success(user))
            } catch let error {
                // update 성공하지 못했을 경우, failure(error)
                single(.failure(RealmStorageError.saveError(error)))
            }

            return Disposables.create()
        }
    }

}
