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
        return self.networkService.getAllowUsers(limit: 10)
            .map { $0.toDomain() }
            .flatMap(fetchBrowseQuestNetworkService(user:))
            .filter { !$0.quests.isEmpty }
            .toArray()
            .asObservable()
            .do(afterNext: { [weak self] browseQuests in
            guard let self = self else { return }
            self.persistentStorage.deleteBrowseQuests()
                .asObservable()
                .concatMap { _ in
                Observable.from(browseQuests)
                    .flatMap (self.saveBrowseQuestPersistentStorage(browseQuest:))
            }
                .subscribe()
                .disposed(by: self.disposeBag)
        })
            .timeout(.seconds(5), scheduler: MainScheduler.instance)
            .catch { _ in
            return self.persistentStorage.fetchBrowseQuests()
        }
    }
}

private extension DefaultBrowseRepository {
    func fetchBrowseQuestNetworkService(user: User) -> Observable<BrowseQuest> {
        networkService
            .read(type: QuestDTO.self, userCase: .anotherUser(user.uuid), access: .quests, filter: .today(Date()))
            .map { $0.toDomain() }
            .toArray()
            .asObservable()
            .map { return BrowseQuest(user: user, quests: $0) }
    }

    func saveBrowseQuestPersistentStorage(browseQuest: BrowseQuest) -> Observable<BrowseQuest> {
        persistentStorage.saveBrowseQuest(browseQuest: browseQuest)
            .asObservable()
    }
}
