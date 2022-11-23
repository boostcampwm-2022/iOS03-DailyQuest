//
//  DefaultQuestsRepository.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/21.
//

import RxSwift
import Foundation

final class DefaultQuestsRepository {

    private let persistentStorage: QuestsStorage

    init(persistentStorage: QuestsStorage) {
        self.persistentStorage = persistentStorage
    }
}

extension DefaultQuestsRepository: QuestsRepository {
    func save(with quest: [Quest]) -> Single<[Quest]> {
        return persistentStorage.saveQuests(with: quest)
    }

    func fetch(by date: Date) -> Observable<[Quest]> {
        return persistentStorage.fetchQuests(by: date)
    }

    func update(with quest: Quest) -> Single<Quest> {
        return persistentStorage.updateQuest(with: quest)
    }

    func delete(with questId: UUID) -> Single<Quest> {
        return persistentStorage.deleteQuest(with: questId)
    }

    func deleteAll(with groupId: UUID) -> Single<[Quest]> {
        return persistentStorage.deleteQuestGroup(with: groupId)
    }


}

extension DefaultQuestsRepository {
    static func test() {
        let persistentStorage = RealmQuestsStorage()
        let repository = DefaultQuestsRepository(persistentStorage: persistentStorage)
        let dummyDate = ["2022-11-17".toDate()!,
                         "2022-11-18".toDate()!,
                         "2022-11-19".toDate()!,
                         "2022-11-20".toDate()!,
                         "2022-11-21".toDate()!,
                         "2022-11-22".toDate()!,
                         "2022-11-23".toDate()!,
                         "2022-11-24".toDate()!]
        let dummyData = (0...10).compactMap { i in
            Quest(groupId: UUID(), uuid: UUID(), date: dummyDate[i % dummyDate.count], title: "\(i) dummyData", currentCount: 0, totalCount: i % 5)
        }

        print("🍀save")
        let _ = repository.save(with: dummyData)
            .subscribe { event in
            print(event)
        }

        print("🍀fetch \(Date())")

        let _ = repository.fetch(by: Date())
            .subscribe { event in
            print(event)
        }

        let temp = dummyData[0]
        print("🍀update \(temp.uuid)")
        let quest = Quest(groupId: temp.groupId, uuid: temp.uuid, date: temp.date, title: "change", currentCount: temp.currentCount + 1, totalCount: temp.totalCount)
        let _ = repository.update(with: quest)
            .subscribe { event in
            print(event)
        }

        print("🍀delete \(dummyData[1].uuid)")
        let _ = repository.delete(with: dummyData[1].uuid)
            .subscribe { event in
            print(event)
        }

    }
}
