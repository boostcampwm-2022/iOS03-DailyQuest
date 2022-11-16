//
//  HomeCoordinator.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

protocol HomeCoordinator: Coordinator {
    func showProfileFlow()
    func showAddQuestFlow()
    func showAddFriendsFlow()
}

final class DefaultHomeCoordinator: HomeCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let homeSceneDIContainer: HomeSceneDIContainer
    
    init(navigationController: UINavigationController,
         homeSceneDIContainer: HomeSceneDIContainer) {
        self.navigationController = navigationController
        self.homeSceneDIContainer = homeSceneDIContainer
    }
    
    func start() {
        let homeViewController = homeSceneDIContainer.makeHomeViewController()
        navigationController.pushViewController(homeViewController, animated: false)
    }
    
    func showProfileFlow() {
        
    }
    
    func showAddQuestFlow() {
        
    }
    
    func showAddFriendsFlow() {
        
    }
}
