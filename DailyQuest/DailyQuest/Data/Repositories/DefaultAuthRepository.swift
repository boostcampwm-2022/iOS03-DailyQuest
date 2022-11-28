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
    protocol AuthRepository {
        func signIn(email: String, password: String) -> Single<Bool> {
            return self.networkService.signIn(email: email, password: password)
        }

        func signOut() -> Single<Bool> {
            return self.networkService.signOut()
        }
    }
}
