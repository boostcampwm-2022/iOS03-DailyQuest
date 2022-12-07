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

    init(persistentStorage: UserInfoStorage, networkService: NetworkService = FirebaseService.shared) {
        self.persistentStorage = persistentStorage
        self.networkService = networkService
    }
}

extension DefaultUserRepository: UserRepository {
    func isLoggedIn() -> BehaviorRelay<String?> {
        return networkService.uid
    }

    func readUser() -> Observable<User> {
        return self.persistentStorage.fetchUserInfo()
            .catch { [weak self] _ in
            guard let self = self else { return Observable.just(User()) }
            return self.fetchUserNetworkService()
        }
    }

    func updateUser(by user: User) -> Observable<User> {
        return persistentStorage.updateUserInfo(user: user)
            .asObservable()
            .flatMap(updateUserNetworkService(user:))
    }

    func fetchUser(by uuid: String) -> Observable<User> {
        return networkService.read(type: UserDTO.self,
                                   userCase: .anotherUser(uuid),
                                   access: .userInfo,
                                   filter: nil)
            .map { $0.toDomain() }
    }
}

extension DefaultUserRepository: ProtectedUserRepository {
    func deleteUser() -> Observable<Bool> {
        // return self.persistentStorage.deleteUserInfo()
        //     .map { _ in true }
        //     .asObservable()
        //     .concatMap { _ in
        //     return self.networkService.delete(userCase: .currentUser, access: .userInfo, dto: UserDTO())
        //         .map { _ in true }
        // }
        return networkService.delete(userCase: .currentUser, access: .userInfo, dto: UserDTO())
            .map { _ in true }
            .catchAndReturn(false)
            .asObservable()
    }
}

private extension DefaultUserRepository {
    func fetchUserNetworkService() -> Observable<User> {
        networkService.read(type: UserDTO.self, userCase: .currentUser, access: .userInfo, filter: nil)
            .map { $0.toDomain() }
    }

    func updateUserNetworkService(user: User) -> Observable<User> {
        networkService.update(userCase: .currentUser, access: .userInfo, dto: user.toDTO())
            .map { $0.toDomain() }
            .asObservable()
            .catchAndReturn(user)
    }
}

