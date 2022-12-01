//
//  DefaultUserRepository.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/12/01.
//

import RxSwift
import RxRelay

final class DefaultUserRepository {

    private let persistentStorage: UserInfoStorage
    private let networkService: NetworkService

    init(persistentStorage: UserInfoStorage, networkService: NetworkService) {
        self.persistentStorage = persistentStorage
        self.networkService = networkService
    }
}

extension DefaultUserRepository: UserRepository {
    func isLoggedIn() -> BehaviorRelay<String?> {
        return self.networkService.uid
    }

    func readUser() -> Observable<User> {
        return self.persistentStorage.fetchUserInfo()
            .catch { networkService.read(type: <#T##DTO.Protocol#>, userCase: .currentUser, access: .userInfo) }
    }

    func updateUser(by user: User) -> Observable<User> {
        return self.persistentStorage.saveUserInfo(user: user).asObservable()
    }

    func deleteUser() -> Observable<Bool> {

    }


}
