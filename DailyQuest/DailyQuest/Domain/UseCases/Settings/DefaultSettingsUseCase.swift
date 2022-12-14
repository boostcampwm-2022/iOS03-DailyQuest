//
//  DefaultSettingsUseCase.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/06.
//

import Foundation

import RxSwift

final class DefaultSettingsUseCase {
    private let userRepository: UserRepository
    private let authRepository: AuthRepository
    
    init(userRepository: UserRepository, authRepository: AuthRepository) {
        self.userRepository = userRepository
        self.authRepository = authRepository
    }
}

extension DefaultSettingsUseCase: SettingsUseCase {
    func isLoggedIn() -> Observable<Bool> {
        return userRepository
            .isLoggedIn()
            .map { id in
                guard let _ = id else { return false }
                return true
            }
            .asObservable()
    }
    
    func signOut() -> Observable<Bool> {
        return authRepository
            .signOut()
            .map { _ in true }
            .catchAndReturn(false)
            .asObservable()
    }
    
    func updateAllow(allow: Bool) -> Single<Bool> {
        userRepository.readUser()
            .map { $0.setAllow(allow: allow) }
            .flatMap(userRepository.updateUser(by:))
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func fetchAllow() -> Single<Bool?> {
        userRepository.readUser()
            .map { $0.allow }
            .catchAndReturn(nil)
    }
    
    func delete() -> Single<Bool> {
        guard let userRepository = userRepository as? ProtectedUserRepository else { return Single.just(false) }
        return userRepository.deleteUser()
            .catchAndReturn(false)
    }
}
