//
//  DefaultUserUseCase.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/12/07.
//

import Foundation
import RxSwift

final class DefaultUserUseCase {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
}

extension DefaultUserUseCase: UserUseCase {
    func isLoggedIn() -> Observable<Bool> {
        return userRepository
            .isLoggedIn()
            .map { id in
                guard let _ = id else { return false }
                return true
            }
            .asObservable()
    }
    
    func fetch() -> Observable<User> {
        return userRepository.readUser()
            .asObservable()
    }
    
    func save(with user: User) -> Observable<User> {
        return userRepository.updateUser(by: user)
            .asObservable()
    }
    
    func saveProfileImage(data: Data) -> Observable<Bool> {
        return userRepository.saveProfileImage(data: data)
            .asObservable()
    }
    
    func saveBackgroundImage(data: Data) -> Observable<Bool> {
        return userRepository.saveBackgroundImage(data: data)
            .asObservable()
    }

    func delete() -> Observable<Bool> {
        guard let userRepository = userRepository as? ProtectedUserRepository else { return Observable.just(false) }
        return userRepository.deleteUser()
            .catchAndReturn(false)
            .asObservable()
    }
}

