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
            .catch { _ in
                return .just(false)
            }
            .asObservable()
    }
}