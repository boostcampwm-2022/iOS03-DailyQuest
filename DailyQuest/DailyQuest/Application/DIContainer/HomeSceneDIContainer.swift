//
//  HomeSceneDIContainer.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

final class HomeSceneDIContainer {
    
    // MARK: - Repositories
    
    // MARK: - Use Cases
    
    // MARK: - View Models
    
    // MARK: - View Controller
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController.create()
    }
    
    // MARK: - Flow
    func makeHomeCoordinator(navigationController: UINavigationController,
                             homeSceneDIContainer: HomeSceneDIContainer) -> HomeCoordinator {
        return DefaultHomeCoordinator(navigationController: navigationController,
                                      homeSceneDIContainer: homeSceneDIContainer)
    }
}
