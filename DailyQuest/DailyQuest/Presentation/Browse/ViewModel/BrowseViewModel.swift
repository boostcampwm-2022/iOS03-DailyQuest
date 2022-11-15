//
//  BrowseViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/15.
//

import Foundation

import RxSwift

final class BrowseViewModel {
    let user = User(uuid: UUID(), nickName: "jinwoong", profile: Data(), backgroundImage: Data(), description: "")
    let quests = [
        Quest(title: "물마시기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 2, totalCount: 5),
        Quest(title: "코딩하기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 0, totalCount: 10)
    ]
    let data: Observable<[(User, [Quest])]>
    
    let cellCount = [2]
    
    init() {
        self.data = .just([(user, quests)])
    }
}
