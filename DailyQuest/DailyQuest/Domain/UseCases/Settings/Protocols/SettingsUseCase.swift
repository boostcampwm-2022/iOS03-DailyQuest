//
//  SettingsUseCase.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/06.
//

import Foundation

import RxSwift

protocol SettingsUseCase {
    func isLoggedIn() -> Observable<Bool>
    func signOut() -> Observable<Bool>
    
    func updateAllow(allow: Bool) -> Single<Bool>
    func fetchAllow() -> Single<Bool?>
    
    func delete() -> Single<Bool>
}
