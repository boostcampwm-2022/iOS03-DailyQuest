//
//  DefaultAuthRepository.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/28.
//

import RxSwift
import Foundation

final class DefaultAuthRepository {
    private let persistentQuestsStorage: QuestsStorage
    private let persistentUserStorage: UserInfoStorage
    private let networkService: NetworkService

    private let disposeBag = DisposeBag()

    init(persistentQuestsStorage: QuestsStorage,
         persistentUserStorage: UserInfoStorage,
         networkService: NetworkService = FirebaseService.shared) {
        self.persistentUserStorage = persistentUserStorage
        self.persistentQuestsStorage = persistentQuestsStorage
        self.networkService = networkService
    }
}

extension DefaultAuthRepository: AuthRepository {
    func signIn(email: String, password: String) -> Single<Bool> {
        return self.networkService.signIn(email: email, password: password)
            .do(onSuccess: { [weak self] result in
            if let self = self, result {
                self.networkService.read(type: UserDTO.self,
                                         userCase: .currentUser,
                                         access: .userInfo,
                                         filter: nil)
                    .map { $0.toDomain() }
                    .flatMap(self.persistentUserStorage.updateUserInfo(user:))
                    .map { _ in true }
                    .catchAndReturn(false)
                    .flatMap { _ in
                    self.networkService.read(type: QuestDTO.self,
                                             userCase: .currentUser,
                                             access: .quests,
                                             filter: nil)
                        .map { $0.toDomain() }
                        .toArray()
                        .flatMap(self.persistentQuestsStorage.saveQuests(with:))
                }
                    .subscribe()
                    .disposed(by: self.disposeBag)
            }
        })
    }

    func signOut() -> Single<Bool> {
        return self.networkService.signOut()
            .do(onSuccess: { [weak self] result in
            if let self = self, result {
                self.persistentUserStorage.deleteUserInfo()
                    .map { _ in true }
                    .catchAndReturn(false)
                    .flatMap { _ in
                    self.persistentQuestsStorage.deleteAllQuests()
                }
                    .subscribe()
                    .disposed(by: self.disposeBag)
            }
        })
    }

    func signUp(email: String, password: String, user: User) -> Single<Bool> {
        return self.networkService.signUp(email: email, password: password, userDto: user.toDTO())
    }
}
