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
            .catch { _ in
            return self.networkService.read(type: UserDTO.self, userCase: .currentUser, access: .userInfo, filter: nil)
                .map { $0.toDomain() }
        }
    }

    func updateUser(by user: User) -> Observable<User> {
        return self.persistentStorage.updateUserInfo(user: user)
            .asObservable()
            .concatMap { _ in
            return self.networkService.update(userCase: .currentUser, access: .userInfo, dto: user.toDTO())
                .map { $0.toDomain() }
                .asObservable()
        }
    }

    func deleteUser() -> Observable<Bool> {
        return self.persistentStorage.deleteUserInfo()
            .map { _ in true }
            .asObservable()
            .concatMap { _ in
            return self.networkService.delete(userCase: .currentUser, access: .userInfo, dto: UserDTO())
                .map { _ in true }
        }
    }
    
    func fetchUser(by uuid: String) -> Observable<User> {
        .just(User(uuid: "", nickName: "", profileURL: "", backgroundImageURL: "", description: "", allow: true))
    }
}