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
    
    func fetch() -> Single<User> {
        return userRepository.readUser()
            .catchAndReturn(User())
            
    }
    
    func save(with user: User) -> Single<User> {
        return userRepository.updateUser(by: user)
            .catchAndReturn(User())
    }
    
    func saveProfileImage(data: Data) -> Single<Bool> {
        return userRepository.saveProfileImage(data: data)
            .catchAndReturn(false)
    }
    
    func saveBackgroundImage(data: Data) -> Single<Bool> {
        return userRepository.saveBackgroundImage(data: data)
            .catchAndReturn(false)
    }

    func delete() -> Single<Bool> {
        guard let userRepository = userRepository as? ProtectedUserRepository else { return Single.just(false) }
        return userRepository.deleteUser()
            .catchAndReturn(false)
    }
}

