//
//  UserQuestsStorage.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/14.
//

import Foundation
import RxSwift

protocol UserQuestsStorage {
    func fetchUserQuests() -> Observable<[Quest]>
    func saveUserQuest(quest: Quest) -> Single<Quest>
}
