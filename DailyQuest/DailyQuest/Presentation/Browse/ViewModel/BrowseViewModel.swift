//
//  BrowseViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/15.
//

import Foundation

import RxSwift

final class BrowseViewModel {
    let user1 = User(uuid: UUID(), nickName: "jinwoong", profile: Data(), backgroundImage: Data(), description: "")
    let quests1 = [
        Quest(uuid: UUID(), title: "물마시기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 2, totalCount: 5),
        Quest(uuid: UUID(), title: "코딩하기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 0, totalCount: 10)
    ]
    
    let user2 = User(uuid: UUID(), nickName: "someone", profile: Data(), backgroundImage: Data(), description: "")
    let quests2 = [
        Quest(uuid: UUID(), title: "물마시기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 4, totalCount: 5),
        Quest(uuid: UUID(), title: "책읽기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 9, totalCount: 20),
        Quest(uuid: UUID(), title: "달리기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 4, totalCount: 9),
        Quest(uuid: UUID(), title: "잠자기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 1, totalCount: 1)
    ]
    
    let user3 = User(uuid: UUID(), nickName: "Max...", profile: Data(), backgroundImage: Data(), description: "")
    let quests3 = [
        Quest(uuid: UUID(), title: "물마시기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 4, totalCount: 5),
        Quest(uuid: UUID(), title: "그림 그리기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 1, totalCount: 2),
        Quest(uuid: UUID(), title: "달리기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 4, totalCount: 9),
        Quest(uuid: UUID(), title: "책읽기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 1, totalCount: 1),
        Quest(uuid: UUID(), title: "잠자기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 1, totalCount: 1),
        Quest(uuid: UUID(), title: "행복하기", startDay: Date(), endDay: Date(), repeat: 1, currentCount: 0, totalCount: 1)
    ]
    
    let data: Observable<[(User, [Quest])]>
    
    let cellCount = [2, 4, 6]
    
    init() {
        self.data = .just([(user1, quests1), (user2, quests2), (user3, quests3)])
    }
}

/**
 Usecase
    - fetching quests, it contains user and his quests.
 */
