//
//  BrowseCoordinator.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

protocol BrowseCoordinator: Coordinator {
    func showDetailFlow()
}

final class DefaultBrowseCoordinator: BrowseCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let browseSceneDIContainer: BrowseSceneDIContainer
    
    init(navigationController: UINavigationController,
         browseSceneDIContainer: BrowseSceneDIContainer) {
        self.navigationController = navigationController
        self.browseSceneDIContainer = browseSceneDIContainer
    }
    
    func start() {
        let browseViewController = browseSceneDIContainer.makeBrowseViewController()
        navigationController.pushViewController(browseViewController, animated: false)
    }
    
    func showDetailFlow() {
        
    }
}

