//
//  DefaultBrowseRepository.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/11/29.
//

import Foundation
import RxSwift

final class DefaultBrowseRepository {

    private let persistentStorage: BrowseQuestsStorage
    private let networkService: NetworkService

    init(persistentStorage: BrowseQuestsStorage, networkService: NetworkService) {
        self.persistentStorage = persistentStorage
        self.networkService = networkService
    }
}

extension DefaultBrowseRepository: BrowseRepository {

    /// Fetch BrowseQuests
    /// Firebase 우선, 실패시 persistentStorage, persistentStorage도 실패시 Error반환
    /// - Returns: Observable<[BrowseQuest]>
    func fetch() -> Observable<[BrowseQuest]> {
        return self.networkService.getAllowUsers(limit: 10)
            .map { $0.toDomain() }
            .flatMap { user in
            self.networkService
                .read(type: QuestDTO.self, userCase: .anotherUser(user.uuid), access: .quests, filter: .today("22-11-30".toDate()!))
                .map { $0.toDomain() }
                .toArray()
                .asObservable()
                .map { questList in
                return BrowseQuest(user: user, quests: questList)
            }
        }

            .filter { !$0.quests.isEmpty }
            .toArray()
            .asObservable()
            .catch { error in
            return self.persistentStorage.fetchBrowseQuests()
        }
            .do(afterNext: { browseQuests in
            _ = self.persistentStorage.deleteBrowseQuests()
                .asObservable()
                .concatMap { _ in
                Observable.from(browseQuests)
                    .flatMap { browseQuest in
                    self.persistentStorage.saveBrowseQuest(browseQuest: browseQuest)
                        .asObservable()
                }
            }
                .subscribe(onError: { error in
                print(error)
            })
        })
    }
}

extension DefaultBrowseRepository {
    static func test() {
        let browseRepository = DefaultBrowseRepository(persistentStorage: RealmBrowseQuestsStorage(), networkService: FirebaseService.shared)
        let fetchBrowseQuestsObserver = browseRepository.fetch()
        _ = fetchBrowseQuestsObserver.subscribe { event in
            print(event)
        }
    }
}
