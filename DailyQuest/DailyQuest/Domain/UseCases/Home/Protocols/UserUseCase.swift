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
    func fetch() -> Observable<User>
    func save(with user: User) -> Observable<User>
    
    func saveProfileImage(data: Data) -> Observable<Bool>
    func saveBackgroundImage(data: Data) -> Observable<Bool>
    
    func delete() -> Observable<Bool>
}
