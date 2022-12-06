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
    private let disposeBag: DisposeBag = DisposeBag()

    init(persistentStorage: BrowseQuestsStorage,
         networkService: NetworkService = FirebaseService.shared) {
        self.persistentStorage = persistentStorage
        self.networkService = networkService
    }
}

extension DefaultBrowseRepository: BrowseRepository {

    /// Fetch BrowseQuests
    /// Firebase 우선, 실패시 persistentStorage, persistentStorage도 실패시 Error반환
    /// - Returns: Observable<[BrowseQuest]>
    func fetch() -> Observable<[BrowseQuest]> {
        return networkService.getAllowUsers(limit: 10)
            .map { $0.toDomain() }
            .flatMap { user in
            self.networkService
                .read(type: QuestDTO.self, userCase: .anotherUser(user.uuid), access: .quests, filter: .today(Date()))
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
            .do(afterNext: { browseQuests in
            self.persistentStorage.deleteBrowseQuests()
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
                }).disposed(by: self.disposeBag)
        })
            .catch { error in
            return self.persistentStorage.fetchBrowseQuests()
        }
    }
}
