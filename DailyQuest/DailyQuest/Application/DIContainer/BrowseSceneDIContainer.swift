//
//  BrowseSceneDIContainer.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

final class BrowseSceneDIContainer {
    
    lazy var browseQuestsStorage: BrowseQuestsStorage = RealmBrowseQuestsStorage()
    lazy var questsStorage: QuestsStorage = RealmQuestsStorage()
    
    // MARK: - Repositories
    func makeBrowseRepository() -> BrowseRepository {
        return DefaultBrowseRepository(persistentStorage: browseQuestsStorage)
    }
    
    func makeQuestsRepository() -> QuestsRepository {
        return DefaultQuestsRepository(persistentStorage: questsStorage)
    }
    
    // MARK: - Use Cases
    func makeBrowseUseCase() -> BrowseUseCase {
        return DefaultBrowseUseCase(browseRepository: makeBrowseRepository())
    }
    
    func makeFriendQuestUseCase() -> FriendQuestUseCase {
        return DefaultFriendUseCase(questsRepository: makeQuestsRepository())
    }
    
    func makeFriendCalendarUseCase(with user: User) -> FriendCalendarUseCase {
        return DefaultFriendCalendarUseCase(user: user, questsRepository: makeQuestsRepository())
    }
    
    // MARK: - View Models
    func makeBrowseViewModel() -> BrowseViewModel {
        return BrowseViewModel(browseUseCase: makeBrowseUseCase())
    }
    
    func makeFriendViewModel(with user: User) -> FriendViewModel {
        return FriendViewModel(user: user,
                               friendQuestUseCase: makeFriendQuestUseCase(),
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

