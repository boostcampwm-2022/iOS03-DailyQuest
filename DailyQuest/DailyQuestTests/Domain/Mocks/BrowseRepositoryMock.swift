//
//  BrowseRepositoryMock.swift
//  DailyQuestTests
//
//  Created by jinwoong Kim on 2022/11/29.
//

import Foundation

import RxSwift

final class BrowseRepositoryMock: BrowseRepository {
    let browseQuests: [BrowseQuest]
    
    init() {
        let user1 = User.stub(nickName: "jinwoong")
        let user2 = User.stub(nickName: "Jose")
        
        let quests = [
            Quest.stub(groupId: UUID(),
                       uuid: UUID(),
                       date: Date(),
                       title: "물마시기",
                       currentCount: 0,
                       totalCount: 10),
            Quest.stub(groupId: UUID(),
                       uuid: UUID(),
                       date: Date(),
                       title: "물마시기",
                       currentCount: 0,
                       totalCount: 10),
        ]
        
        self.browseQuests = [BrowseQuest.stub(user: user1, quests: quests),
                             BrowseQuest.stub(user: user2, quests: quests)]
    }
    
    func fetch() -> Observable<[BrowseQuest]> {
        return .just(browseQuests)
    }
}
