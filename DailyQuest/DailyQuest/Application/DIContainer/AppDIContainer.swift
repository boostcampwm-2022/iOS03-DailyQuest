//
//  AppDIContainer.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import Foundation
import DailyContainer

final class AppDIContainer {
    
    init() {
        registerService()
        registerStorage()
        registerRepository()
    }
    
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        return HomeSceneDIContainer()
    }
    
    func makeBrowseSceneDIContainer() -> BrowseSceneDIContainer {
        return BrowseSceneDIContainer()
    }
    
    func makeSettingsSceneDIContainer() -> SettingsSceneDIContainer {
        return SettingsSceneDIContainer()
    }
}

private extension AppDIContainer {
    func registerService() {
        Container.shared.register {
            Module(ServiceKey.self) { FirebaseService.shared }
        }
    }
    
    func registerStorage() {
        Container.shared.register {
            Module(QuestStorageKey.self) { RealmQuestsStorage() }
            Module(BrowseQuestStorageKey.self) { RealmBrowseQuestsStorage() }
            Module(UserInfoStorageKey.self) { RealmUserInfoStorage() }
        }
    }
    
    func registerRepository() {
        Container.shared.register {
            Module(QuestRepositoryKey.self) {
                @Injected(QuestStorageKey.self)
                var questStorage: QuestsStorage
                return DefaultQuestsRepository(persistentStorage: questStorage)
            }
            
            Module(AuthRepositoryKey.self) {
                @Injected(QuestStorageKey.self)
                var questStorage: QuestsStorage
                
                @Injected(UserInfoStorageKey.self)
                var userInfoStorage: UserInfoStorage
                
                return DefaultAuthRepository(persistentQuestsStorage: questStorage,
                                             persistentUserStorage: userInfoStorage)
            }
            
            Module(BrowseRepositoryKey.self) {
                @Injected(BrowseQuestStorageKey.self)
                var browseQuestStroage: BrowseQuestsStorage
                
                @Injected(ServiceKey.self)
                var networkService: NetworkService
                
                return DefaultBrowseRepository(persistentStorage: browseQuestStroage,
                                               networkService: networkService)
            }
            
            /**
             Networ service instance needed.
             */
            Module(UserRepositoryKey.self) {
                @Injected(UserInfoStorageKey.self)
                var userInfoStorage: UserInfoStorage
                
                return DefaultUserRepository(persistentStorage: userInfoStorage)
            }
            
            /**
             Protected User Repository Injection
             goes here.
             */
        }
    }

}
