//
//  BrowseQuestsStorage.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/15.
//

import RxSwift

protocol BrowseQuestsStorage {
    func fetchBrowseQuests() -> Observable<[BrowseQuest]>
    func saveBrowseQuest(browseQuest: BrowseQuest) -> Single<BrowseQuest>
    func deleteBrowseQuests() -> Single<Bool>
}
