//
//  BrowseViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/15.
//

import Foundation

import RxSwift

final class BrowseViewModel {
    let user1 = User(uuid: "", nickName: "jinwoong", profileURL: "", backgroundImageURL: "", description: "", allow: false)
    let quests1 = [
        Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "물마시기", currentCount: 2, totalCount: 5),
        Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "코딩하기", currentCount: 0, totalCount: 10)
    ]

    let data: Observable<[(User, [Quest])]>
    private(set) var users: [User] = []

    let cellCount = [2]

    init() {
        self.data = .just([(user1, quests1)])
        self.users.append(contentsOf: [user1])
    }
}

/**
 Usecase
    - fetching quests, it contains user and his quests.
 */
