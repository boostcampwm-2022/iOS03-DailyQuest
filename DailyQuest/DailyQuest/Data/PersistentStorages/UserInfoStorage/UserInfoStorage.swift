//
//  UserInfoStorage.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/15.
//

import RxSwift

protocol UserInfoStorage {
    func fetchUserInfo() -> Observable<User>
    func updateUserInfo(user: User) -> Single<User>
    func deleteUserInfo() -> Single<User>
}
