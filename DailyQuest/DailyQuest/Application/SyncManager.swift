//
//  SyncManager.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/12/09.
//

import UIKit
import RxSwift

final class SyncManager {
    private let app = UIApplication.shared
    private let persistentStorage: RealmStorage = RealmStorage.shared
    private let networkStorage: NetworkService = FirebaseService.shared
    
    private let disposeBag = DisposeBag()
    
    func sync(){
        guard FirebaseService.shared.uid.value != nil else {return }
        let taskId = app.beginBackgroundTask()
        self.questsSync()
            .timeout(.seconds(20), scheduler: MainScheduler.instance)
            .subscribe(onSuccess:{ res in
                print("✅",res)
                self.app.endBackgroundTask(taskId)
            },onFailure: { error in
                print("❌",error)
                self.app.endBackgroundTask(taskId)
            }, onDisposed: {
                print("disposed")
            })
            .disposed(by: disposeBag)
    }
    
    private func questsSync() -> Single<Bool> {
        self.fetchQuests()
            .flatMap { [weak self] persistentStorageQuest in
                guard let self = self else { return Single<[Quest]>.just([]) }
                return self.networkStorage.read(type: QuestDTO.self, userCase: .currentUser, access: .quests, filter: nil)
                    .map { $0.toDomain() }
                    .toArray()
                    .map { networkServiceQuests in
                        let networkServiceQuestsDict = Dictionary(uniqueKeysWithValues: networkServiceQuests.map { ($0.uuid, $0) })
                        let quests = persistentStorageQuest.filter {
                            guard let dictQuest = networkServiceQuestsDict[$0.uuid] else { return true }
                            return dictQuest != $0
                        }
                        return quests
                    }
            }
            .flatMap{ [weak self] syncQuests in
                guard let self = self else { return Single<Bool>.just(false)}
                return Observable<Quest>.from(syncQuests)
                    .flatMap { quest in
                        self.networkStorage.create(userCase: .currentUser, access: .quests, dto: quest.toDTO())
                    }
                    .map{$0.toDomain()}
                    .toArray()
                    .map{ _ in true}
            }
    }
    
    private func fetchQuests() -> Single<[Quest]> {
        return Single.create { [weak self] single in
            guard let persistentStorage = self?.persistentStorage else {
                single(.failure(RealmStorageError.noDataError))
                return Disposables.create()
            }
            
            do {
                let quests = try persistentStorage
                    .readEntities(type: QuestEntity.self, filter: nil)
                    .compactMap { $0.toDomain() }
                single(.success(quests))
            } catch let error {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}
