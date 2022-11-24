//
//  SettingsSceneDIContainer.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

final class SettingsSceneDIContainer {
    
    // MARK: - Repositories
    
    // MARK: - Use Cases
    
    // MARK: - View Models
    
    // MARK: - View Controller
    
    // MARK: - Flow
    func makeSettingsCoordinator(navigationController: UINavigationController,
                                 settingsSceneDIContainer: SettingsSceneDIContainer) -> SettingsCoordinator {
        return DefaultSettingsCoordinator(navigationController: navigationController,
                                          settingsSceneDIContainer: settingsSceneDIContainer)
    }
}
