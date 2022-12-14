//
//  BrowseRepository.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/29.
//

import RxSwift

protocol BrowseRepository {
    // TODO: 무한 스크롤을 위한 페이징 추가
    func fetch() -> Single<[BrowseQuest]>
}
