//
//  SettingsCoordinator.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/23.
//

import UIKit

protocol SettingsCoordinator: Coordinator {
    func showLoginOutFlow()
}

final class DefaultSettingsCoordinator: SettingsCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let settingsSceneDIContainer: SettingsSceneDIContainer
    
    init(navigationController: UINavigationController,
         settingsSceneDIContainer: SettingsSceneDIContainer) {
        self.navigationController = navigationController
        self.settingsSceneDIContainer = settingsSceneDIContainer
    }
    
    func start() {
        let settingsController = SettingsViewController()
        navigationController.pushViewController(settingsController, animated: false)
    }
    
    func showLoginOutFlow() {
        /**
         Show Login view
         */
    }
}
