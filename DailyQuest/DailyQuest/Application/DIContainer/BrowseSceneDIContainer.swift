//
//  BrowseSceneDIContainer.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

final class BrowseSceneDIContainer {
    
    // MARK: - Repositories
    
    // MARK: - Use Cases
    
    // MARK: - View Models
    func makeBrowseViewModel() -> BrowseViewModel {
        return BrowseViewModel()
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

