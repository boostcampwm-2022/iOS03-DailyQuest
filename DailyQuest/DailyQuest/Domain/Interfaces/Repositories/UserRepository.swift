//
//  UserRepository.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/01.
//

import Foundation
import RxSwift
import RxRelay

protocol UserRepository {
    /// 로그인되어 있는지 확인합니다.
    /// - Returns: 성공하면 uid정보를 방출하는 relay입니다.
    func isLoggedIn() -> BehaviorRelay<String?>
    
    /// 유저정보를 불러옵니다.
    /// - Returns: 유저의 정보를 방출하는 Observable을 반환합니다.
    func readUser() -> Single<User>
    
    /// 유저정보를 업데이트합니다.
    /// - Parameter user: 바뀐 유저 정보입니다.
    /// - Returns: 성공적으로 바뀐 유저의 정보를 방출하는 Observable입니다.
    func updateUser(by user: User) -> Single<User>
    
    func saveProfileImage(data: Data) -> Single<Bool>
    
    func saveBackgroundImage(data: Data) -> Single<Bool>
    
    func fetchUser(by uuid: String) -> Single<User>
    
    
}
