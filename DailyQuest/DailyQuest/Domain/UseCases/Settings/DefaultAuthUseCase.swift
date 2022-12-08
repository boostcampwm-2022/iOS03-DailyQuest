//
//  DefaultAuthUseCase.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/28.
//

import Foundation

import RxSwift

final class DefaultAuthUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
}

extension DefaultAuthUseCase: AuthUseCase {
    func signIn(email: String, password: String) -> Observable<Bool> {
        return authRepository
            .signIn(email: email, password: password)
            .catch { _ in
            return .just(false)
        }
            .asObservable()
    }

    func signOut() -> Observable<Bool> {
        return authRepository
            .signOut()
            .catchAndReturn(false)
            .asObservable()
    }

    func signUp(email: String, password: String, user: User) -> Observable<Bool> {
        return authRepository
            .signUp(email: email, password: password, user: user)
            .catch { _ in
            return .just(false)
        }
            .asObservable()
    }
}
