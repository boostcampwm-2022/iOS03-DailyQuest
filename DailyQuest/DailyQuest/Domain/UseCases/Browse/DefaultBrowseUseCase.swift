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
    func excute() -> RxSwift.Observable<[BrowseQuest]> {
        return browseRepository.fetch()
    }
}
