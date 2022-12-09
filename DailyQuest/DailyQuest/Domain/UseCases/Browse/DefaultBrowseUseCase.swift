//
//  DefaultBrowseUseCase.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/29.
//

import Foundation

import RxSwift

final class DefaultBrowseUseCase {
    private let browseRepository: BrowseRepository
    
    init(browseRepository: BrowseRepository) {
        self.browseRepository = browseRepository
    }
}

extension DefaultBrowseUseCase: BrowseUseCase {
    func excute() -> Single<[BrowseQuest]> {
        return browseRepository.fetch()
    }
}

final class BrowseMockRepo: BrowseRepository {
    func fetch() -> Single<[BrowseQuest]> {
        return .just([BrowseQuest(user: User(uuid: "", nickName: "test", profileURL: "", backgroundImageURL: "", introduce: "", allow: false), quests: [])])
    }
}
