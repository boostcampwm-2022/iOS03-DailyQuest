//
//  AuthRepository.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/28.
//

import RxSwift

protocol AuthRepository {
    /// 로그인 동작을 수행합니다.
    ///
    /// - Parameters:
    ///   - email: 사용자의 email 입니다.
    ///   - password: 사용자의 password입니다.
    /// - Returns: 성공하면 true를, 실패하면 error를 방출하는 Observable을 반환합니다.
    func signIn(email: String, password: String) -> Single<Bool>
    
    /// 로그아웃 동작을 수행합니다.
    /// - Returns: 성공하면 true를, 실패하면 error을 방출하는 Observable을 반환합니다.
    func signOut() -> Single<Bool>
}
