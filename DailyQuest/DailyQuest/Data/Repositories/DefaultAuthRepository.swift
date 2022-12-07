//
//  DefaultAuthRepository.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/28.
//

import RxSwift
import Foundation

final class DefaultAuthRepository {

    private let networkService: NetworkService

    init(networkService: NetworkService = FirebaseService.shared) {
        self.networkService = networkService
    }
}

extension DefaultAuthRepository: AuthRepository {
    func signIn(email: String, password: String) -> Single<Bool> {
        return self.networkService.signIn(email: email, password: password)
    }

    func signOut() -> Single<Bool> {
        return self.networkService.signOut()
    }

    func signUp(email: String, password: String, user: User) -> Single<Bool> {
        return self.networkService.signUp(email: email, password: password, userDto: user.toDTO())
    }
}
