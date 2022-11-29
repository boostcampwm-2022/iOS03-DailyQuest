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
    func fetch() -> Observable<[BrowseQuest]> {
        return Observable.create { observer in
            let allowUsers = self.networkService.getAllowUsers(limit: 10)
            var users: [User] = []
            var browseQuests: [BrowseQuest] = []
            _ = allowUsers.subscribe{ event in
                if let error = event.error {
                    observer.onError(error)
                    
                } else if let user = event.element {
                    users.append(user.toDomain())
                } else if event.isCompleted {
                    users.forEach { user in
                        let questObserver = self.networkService
                            .read(type: QuestDTO.self, userCase: .anotherUser(user.uuid), access: .quests, filter: .today(Date()))
                        var quests:[Quest] = []
                        questObserver.subscribe{ questEvent in
                            if let quest = questEvent.element {
                                quests.append( quest.toDomain())
                            } else if questEvent.isCompleted{
                                let browseQuest = BrowseQuest(user: user, quests: quests)
                                browseQuests.append(browseQuest)
                                if browseQuests.count == users.count {
                                    observer.onNext(browseQuests.filter { $0.quests.count != 0 })
                                }
                            }
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    
    static func test() {
        //                for _ in (0...10){
        //                    let dto = UserDTO(uuid: UUID().uuidString, nickName: "엄", profileURL: "엄", backgroundImageURL: "엄", description: "엄", allow: false)
        //                    let a = FirebaseService.shared.create(userCase: .anotherUser(dto.uuid), access: .userInfo, dto: dto)
        //                    _ = a.subscribe { ev in
        //                        print(ev)
        //                        let dummyDate = ["2022-11-29",
        //                                         "2022-11-29",
        //                                         "2022-11-30",
        //                                         "2022-11-02",
        //                                         "2022-11-05",
        //                                         "2022-11-06",
        //                                         "2022-11-01",
        //                                         "2022-11-11"]
        //                        (0...10).forEach { i in
        //                            let questDTO = QuestDTO(groupId: UUID(), uuid: UUID().uuidString, date: dummyDate[i % dummyDate.count], title: "\(i) dummyData", currentCount: 0, totalCount:  i % 5 + 1)
        //                            let b = FirebaseService.shared.create(userCase: .anotherUser(dto.uuid), access: .quests, dto: questDTO)
        //                            b.subscribe { event in
        //                                print(event)
        //                            }
        //                        }
        //                    }
        //                }
        
        let a = DefaultBrowseRepository(persistentStorage: RealmBrowseQuestsStorage(), networkService: FirebaseService.shared)
        let b = a.fetch()
        b.subscribe { eve in
            print(eve)
        }
    }
}
