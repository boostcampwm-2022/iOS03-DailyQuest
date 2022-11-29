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
            var result: [BrowseQuest] = []
            _ = allowUsers.subscribe{ event in
                if let error = event.error {
                    observer.onError(error)
                } else if event.isCompleted{
                    observer.onNext(result)
                    observer.onCompleted()
                } else if let user = event.element {
                    let s = self.networkService
                        .read(type: QuestDTO.self, userCase: .anotherUser(user.uuid), access: .quests, filter: .today(Date()))
                }
            }
            return Disposables.create()
        }
    }
    
    
    static func test() {
        //        for _ in (0...10){
        //            let dto = UserDTO(uuid: "엄-\(UUID())", nickName: "엄", profile: "엄", backgroundImage: "엄", description: "엄", allow: false)
        //            let a = FirebaseService.shared.create(userCase: .anotherUser(dto.uuid), access: .userInfo, dto: dto)
        //            _ = a.subscribe { ev in
        //                print(ev)
        //                let dummyDate = ["2022-11-17",
        //                                 "2022-11-18",
        //                                 "2022-11-19",
        //                                 "2022-11-20",
        //                                 "2022-11-21",
        //                                 "2022-11-22",
        //                                 "2022-11-23",
        //                                 "2022-11-24"]
        //                (0...10).forEach { i in
        //                    let questDTO = QuestDTO(groupId: UUID(), uuid: UUID().uuidString, date: dummyDate[i % dummyDate.count], title: "\(i) dummyData", currentCount: 0, totalCount:  i % 5 + 1)
        //                    let b = FirebaseService.shared.create(userCase: .anotherUser(dto.uuid), access: .quests, dto: questDTO)
        //                    b.subscribe { event in
        //                        print(event)
        //                    }
        //                }
        //            }
        //        }
        
        let a = FirebaseService.shared.getAllowUsers(limit: 10)
        a.subscribe { eve in
            print(eve)
            print(eve.element?.uuid, eve.element?.allow)
        }
    }
}
