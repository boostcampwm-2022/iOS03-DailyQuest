//
//  BrowseSceneDIContainer.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

final class BrowseSceneDIContainer {
    
    lazy var browseQuestsStorage: BrowseQuestsStorage = RealmBrowseQuestsStorage()
    
    // MARK: - Repositories
    func makeBrowseRepository() -> BrowseRepository {
        return DefaultBrowseRepository(persistentStorage: browseQuestsStorage)
    }
    
    // MARK: - Use Cases
    func makeBrowseUseCase() -> BrowseUseCase {
        return DefaultBrowseUseCase(browseRepository: makeBrowseRepository())
    }
    
    // MARK: - View Models
    func makeBrowseViewModel() -> BrowseViewModel {
        return BrowseViewModel(browseUseCase: makeBrowseUseCase())
    }
    
    // MARK: - View Controller
    func makeBrowseViewController() -> BrowseViewController {
        return BrowseViewController.create(with: makeBrowseViewModel())
    }
    
    // MARK: - Flow
    func makeBrowseCoordinator(navigationController: UINavigationController,
                             browseSceneDIContainer: BrowseSceneDIContainer) -> BrowseCoordinator {
        return DefaultBrowseCoordinator(navigationController: navigationController,
                                      browseSceneDIContainer: browseSceneDIContainer)
    }
}

