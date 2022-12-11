//
//  DefaultUserRepository.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/12/01.
//

import Foundation
import RxSwift
import RxRelay

final class DefaultUserRepository {
    
    private let persistentStorage: UserInfoStorage
    private let networkService: NetworkService
    
    private let disposeBag = DisposeBag()
    
    init(persistentStorage: UserInfoStorage, networkService: NetworkService = FirebaseService.shared) {
        self.persistentStorage = persistentStorage
        self.networkService = networkService
    }
}

extension DefaultUserRepository: UserRepository {
    func isLoggedIn() -> BehaviorRelay<String?> {
        return networkService.uid
    }
    
    func readUser() -> Single<User> {
        return self.persistentStorage.fetchUserInfo()
            .catch { [weak self] _ in
                guard let self = self else { return Single.just(User()) }
                return self.fetchUserNetworkService()
            }
    }
    
    func updateUser(by user: User) -> Single<User> {
        return persistentStorage.updateUserInfo(user: user)
            .flatMap(updateUserNetworkService(user:))
    }
    
    func fetchUser(by uuid: String) -> Single<User> {
        return networkService.read(type: UserDTO.self,
                                   userCase: .anotherUser(uuid),
                                   access: .userInfo,
                                   filter: nil)
        .map { $0.toDomain() }
        .asSingle()
    }
    
    func saveProfileImage(data: Data) -> Single<Bool> {
        networkService.uploadDataStorage(data: data, path: .profileImages)
            .flatMap { [weak self] downloadUrl in
                guard let self = self else { return Single.just(User()) }
                return self.persistentStorage.fetchUserInfo()
                    .flatMap { user in
                        return self.networkService.deleteDataStorage(forUrl: user.profileURL)
                            .catchAndReturn(false)
                            .map{ _ in user }
                    }
                    .map { $0.setProfileImageURL(profileURL: downloadUrl).toDTO() }
                    .flatMap{ userDto in
                        return self.networkService.update(userCase: .currentUser, access: .userInfo, dto: userDto)
                    }
                    .map { $0.toDomain() }
            }
            .flatMap(updateUser(by:))
            .map { _ in true }
            .catchAndReturn(false)
            .do(afterSuccess: { result in
                NotificationCenter.default.post(name: .userUpdated, object: result)
            })
    }
    
    func saveBackgroundImage(data: Data) -> Single<Bool> {
        networkService.uploadDataStorage(data: data, path: .backgroundImages)
            .flatMap { [weak self] downloadUrl in
                guard let self = self else { return Single.just(User()) }
                return self.persistentStorage.fetchUserInfo()
                    .flatMap { user in
                        self.networkService.deleteDataStorage(forUrl: user.backgroundImageURL)
                            .catchAndReturn(false)
                            .map{ _ in user }
                    }
                    .map { $0.setBackgroundImageURL(backgroundImageURL: downloadUrl).toDTO() }
                    .flatMap{ userDto in
                        return self.networkService.update(userCase: .currentUser, access: .userInfo, dto: userDto)
                    }
                    .map { $0.toDomain() }
            }
            .flatMap(updateUser(by:))
            .map { _ in true }
            .catchAndReturn(false)
            .do(afterSuccess: { _ in
                NotificationCenter.default.post(name: .userUpdated, object: nil)
            })
                }
    
}

extension DefaultUserRepository: ProtectedUserRepository {
    func deleteUser() -> Single<Bool> {
        return networkService
            .delete(userCase: .currentUser, access: .userInfo, dto: UserDTO())
            .catchAndReturn(UserDTO())
            .flatMap { [weak self] _ in
                guard let self = self else { return .just(false) }
                return self.networkService.deleteUser()
                    .flatMap { _ in
                        return self.persistentStorage.deleteUserInfo()
                            .map{ _ in true}
                            .catchAndReturn(true)
                    }
            }
            .catchAndReturn(false)
            .do(onSuccess: { [weak self]_ in
                guard let self = self else { return }
                self.networkService.signOut().subscribe()
                    .disposed(by: self.disposeBag)
            })
    }
}

private extension DefaultUserRepository {
    func fetchUserNetworkService() -> Single<User> {
        networkService.read(type: UserDTO.self, userCase: .currentUser, access: .userInfo, filter: nil)
            .map { $0.toDomain() }
            .asSingle()
    }
    
    func updateUserNetworkService(user: User) -> Single<User> {
        networkService.update(userCase: .currentUser, access: .userInfo, dto: user.toDTO())
            .map { $0.toDomain() }
            .catchAndReturn(user)
    }
}

