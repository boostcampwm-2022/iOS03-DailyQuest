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
                return Disposables.create()
            }

            do {
                // User 정보가 없을 경우 noDataError 발생
                guard let userInfoEntity = try realmStorage.fetchEntities(type: UserInfoEntity.self)
                    .first else {
                    throw RealmStorageError.noDataError
                }

                observer.onNext(userInfoEntity.toDomain())
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }

    func saveUserInfo(user: User) -> Single<User> {
        return Single.create { [weak self] single in
            guard let realmStorage = self?.realmStorage else {
                return Disposables.create()
            }

            let userInfo = UserInfoEntity(user: user)

            do {
                
                try realmStorage.updateEntity(entity: userInfo)
                single(.success(user))
            } catch let error {
                single(.failure(RealmStorageError.saveError(error)))
            }

            return Disposables.create()
        }
    }


}
