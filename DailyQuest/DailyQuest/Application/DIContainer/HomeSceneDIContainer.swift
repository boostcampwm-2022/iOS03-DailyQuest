//
//  HomeSceneDIContainer.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

final class HomeSceneDIContainer {
    
    lazy var questsStorage: QuestsStorage = RealmQuestsStorage()
    
    // MARK: - Repositories
    func makeQuestsRepository() -> QuestsRepository {
        return DefaultQuestsRepository(persistentStorage: questsStorage)
    }
    
    // MARK: - Use Cases
    func makeQuestUseCase() -> QuestUseCase {
        return DefaultQuestUseCase(questsRepository: makeQuestsRepository())
    }
    
    // MARK: - View Models
    func makeQuestViewModel() -> QuestViewModel {
        return QuestViewModel(questUseCase: makeQuestUseCase())
    }
    
    // MARK: - View Controller
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController.create(with: makeQuestViewModel())
    }
    
    // MARK: - Flow
    func makeHomeCoordinator(navigationController: UINavigationController,
                             homeSceneDIContainer: HomeSceneDIContainer) -> HomeCoordinator {
        return DefaultHomeCoordinator(navigationController: navigationController,
                                      homeSceneDIContainer: homeSceneDIContainer)
    }
}
