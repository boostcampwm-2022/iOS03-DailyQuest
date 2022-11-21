//
//  QuestsStorage.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/14.
//

import Foundation
import RxSwift

protocol QuestsStorage {
    func saveQuests(with quests: [Quest]) -> Single<[Quest]>
    func fetchQuests(by date: Date) -> Observable<[Quest]>
    func updateQuest(with quest: Quest) -> Single<Quest>
    func deleteQuest(with questId: UUID) -> Single<Quest>
    func deleteQuestGroup(with groupId: UUID) -> Single<[Quest]>
}
