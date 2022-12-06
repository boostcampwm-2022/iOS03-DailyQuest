//
//  UserUseCase.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/12/07.
//

import RxSwift

protocol UserUseCase {
    func fetch() -> Observable<User>
    func save(with user: User) -> Observable<User>
}
