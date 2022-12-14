//
//  UserUseCase.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/12/07.
//

import Foundation
import RxSwift

protocol UserUseCase {
    func isLoggedIn() -> Observable<Bool>
    func fetch() -> Single<User>
    func save(with user: User) -> Single<User>
    
    func saveProfileImage(data: Data) -> Single<Bool>
    func saveBackgroundImage(data: Data) -> Single<Bool>
    
    func delete() -> Single<Bool>
    
    func updateIntroduce(introduce: String) -> Single<Bool>
}
