//
//  AuthUseCase.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/28.
//

import Foundation

import RxSwift

protocol AuthUseCase {
    func signIn(email: String, password: String) -> Observable<Bool>
    func signOut() -> Observable<Bool>
    func signUp(email: String, password: String, user: User) -> Observable<Bool>
}
