//
//  BrowseSceneDIContainer.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

import DailyContainer

final class BrowseSceneDIContainer {
    
    init() {
        registerUseCase()
    }
    
    // MARK: - Use Cases
    func makeFriendCalendarUseCase(with user: User) -> CalendarUseCase {
        @Injected(QuestRepositoryKey.self)
        var questRepository: QuestsRepository
        
        return DefaultFriendCalendarUseCase(user: user,
                                            questsRepository: questRepository)
    }
    
    // MARK: - View Models
    func makeBrowseViewModel() -> BrowseViewModel {
        @Injected(BrowseUseCaseKey.self)
        var browseUseCase: BrowseUseCase
        
        return BrowseViewModel(browseUseCase: browseUseCase)
    }
    
    func makeFriendViewModel(with user: User) -> FriendViewModel {
        @Injected(FriendQuestUseCaseKey.self)
        var friendQuestUseCase: FriendQuestUseCase
        
        return FriendViewModel(user: user,
                               friendQuestUseCase: friendQuestUseCase,
                               friendCalendarUseCase: makeFriendCalendarUseCase(with: user))
    }
    
    // MARK: - View Controller
    func makeBrowseViewController() -> BrowseViewController {
        return BrowseViewController.create(with: makeBrowseViewModel())
    }
    
    func makeFriendViewController(with user: User) -> FriendViewController {
        return FriendViewController.create(with: makeFriendViewModel(with: user))
    }
    
    // MARK: - Flow
    func makeBrowseCoordinator(navigationController: UINavigationController,
                             browseSceneDIContainer: BrowseSceneDIContainer) -> BrowseCoordinator {
        return DefaultBrowseCoordinator(navigationController: navigationController,
                                      browseSceneDIContainer: browseSceneDIContainer)
    }
}

private extension BrowseSceneDIContainer {
    func registerUseCase() {
        Container.shared.register {
            Module(BrowseUseCaseKey.self) {
                @Injected(BrowseRepositoryKey.self)
                var browseRepository: BrowseRepository
                
                return DefaultBrowseUseCase(browseRepository: browseRepository)
            }
            
            Module(FriendQuestUseCaseKey.self) {
                @Injected(QuestRepositoryKey.self)
                var questRepository: QuestsRepository
                
                return DefaultFriendUseCase(questsRepository: questRepository)
            }
        }
    }
}
