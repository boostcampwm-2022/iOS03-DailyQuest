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
    ///
    ///
    /// - Returns: Observable<[BrowseQuest]>
    func fetch() -> Observable<[BrowseQuest]> {
        return Observable.create { observer in
            let allowUsers = self.networkService.getAllowUsers(limit: 10)
            var users: [User] = []
            var browseQuests: [BrowseQuest] = []
            _ = allowUsers.subscribe { event in
                if let error = event.error {
                    _ = self.persistentStorage.fetchBrowseQuests()
                        .subscribe { event in
                        if let persistentStorageError = event.error {
                            // 인터넷 에러가 발생하여 데이터를 가져오지 못 하고, persistentStorage에서도 에러 발생시
                            observer.onError(persistentStorageError)
                        } else if let persistentBrowseQuests = event.element {
                            observer.onNext(persistentBrowseQuests)
                        } else if event.isCompleted {
                            observer.onError(error)
                        }
                    }
                } else if let user = event.element {
                    users.append(user.toDomain())
                } else if event.isCompleted {
                    users.forEach { user in
                        let questObserver = self.networkService
                            .read(type: QuestDTO.self, userCase: .anotherUser(user.uuid), access: .quests, filter: .today(Date()))
                        var quests: [Quest] = []
                        _ = questObserver.subscribe { questEvent in
                            if let quest = questEvent.element {
                                quests.append(quest.toDomain())
                            } else if questEvent.isCompleted {
                                let browseQuest = BrowseQuest(user: user, quests: quests)
                                browseQuests.append(browseQuest)
                                if browseQuests.count == users.count {
                                    let browseQuestsFilter = browseQuests.filter { $0.quests.count != 0 }
                                    browseQuestsFilter.forEach { browseQuest in
                                        let a = self.persistentStorage.saveBrowseQuest(browseQuest: browseQuest)
                                        a.subscribe { ev in
                                            print("✅", ev)
                                        }
                                    }
                                    observer.onNext(browseQuestsFilter)
                                }
                            }
                        }
                    }
                }
            }
            return Disposables.create()
        }
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
