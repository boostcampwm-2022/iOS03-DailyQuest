//
//  DefaultUserUseCase.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/12/07.
//

import RxSwift

final class DefaultUserUseCase {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
}

extension DefaultUserUseCase: UserUseCase {
    func fetch() -> Observable<User> {
        return userRepository.readUser()
    }

    func save(with user: User) -> Observable<User> {
        return userRepository.updateUser(by: user)
    }

    func delete() -> Observable<Bool> {
        guard let userRepository = userRepository as? ProtectedUserRepository else { return Observable.just(false) }
        return userRepository.deleteUser()
            .catchAndReturn(false)
    }
}

