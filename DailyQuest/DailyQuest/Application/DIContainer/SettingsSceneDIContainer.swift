//
//  SettingsSceneDIContainer.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

final class SettingsSceneDIContainer {
    
    // MARK: - Repositories
    func makeAuthRepository() -> AuthRepository {
        return DefaultAuthRepository()
    }
    
    // MARK: - Use Cases
    func makeAuthUseCase() -> AuthUseCase {
        return DefaultAuthUseCase(authRepository: makeAuthRepository())
    }
    
    // MARK: - View Models
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(authUseCase: makeAuthUseCase())
    }
    
    // MARK: - View Controller
    func makeLoginViewController() -> LoginViewController {
        return LoginViewController.create(with: makeLoginViewModel())
    }
    
    // MARK: - Flow
    func makeSettingsCoordinator(navigationController: UINavigationController,
                                 settingsSceneDIContainer: SettingsSceneDIContainer) -> SettingsCoordinator {
        return DefaultSettingsCoordinator(navigationController: navigationController,
                                          settingsSceneDIContainer: settingsSceneDIContainer)
    }
}
