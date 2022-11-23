//
//  BrowseViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/15.
//

import Foundation

import RxSwift

final class BrowseViewModel {
    let user1 = User(uuid: "", nickName: "jinwoong", profile: Data(), backgroundImage: Data(), description: "")
    let quests1 = [
        Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "물마시기", currentCount: 2, totalCount: 5),
        Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "코딩하기", currentCount: 0, totalCount: 10)
    ]

    let user2 = User(uuid: "", nickName: "someone", profile: Data(), backgroundImage: Data(), description: "")
    let quests2 = [
        Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "물마시기", currentCount: 4, totalCount: 5),
        Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "책읽기", currentCount: 9, totalCount: 20),
        Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "달리기", currentCount: 4, totalCount: 9),
        Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "잠자기", currentCount: 1, totalCount: 1)
    ]

    let user3 = User(uuid: "", nickName: "Max...", profile: Data(), backgroundImage: Data(), description: "")
    let quests3 = [
        Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "물마시기", currentCount: 4, totalCount: 5),
        Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "그림 그리기", currentCount: 1, totalCount: 2),
        Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "달리기", currentCount: 4, totalCount: 9),
        Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "책읽기", currentCount: 1, totalCount: 1),
        Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "잠자기", currentCount: 1, totalCount: 1),
        Quest(groupId: UUID(), uuid: UUID(), date: Date(), title: "행복하기", currentCount: 0, totalCount: 1)
    ]

    let data: Observable<[(User, [Quest])]>
    private(set) var users: [User] = []

    let cellCount = [2, 4, 6]

    init() {
        self.data = .just([(user1, quests1), (user2, quests2), (user3, quests3)])
        self.users.append(contentsOf: [user1, user2, user3])
    }
}

/**
 Usecase
    - fetching quests, it contains user and his quests.
 */
