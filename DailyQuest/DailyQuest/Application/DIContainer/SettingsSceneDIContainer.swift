//
//  SettingsSceneDIContainer.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

final class SettingsSceneDIContainer {

    lazy var userInfoStorage: UserInfoStorage = RealmUserInfoStorage()

    // MARK: - Repositories
    func makeAuthRepository() -> AuthRepository {
        return DefaultAuthRepository()
    }

    func makeUserRepository() -> UserRepository {
        return DefaultUserRepository(persistentStorage: userInfoStorage)
    }

    // MARK: - Use Cases
    func makeAuthUseCase() -> AuthUseCase {
        return DefaultAuthUseCase(authRepository: makeAuthRepository())
    }

    func makeSettingsUseCase() -> SettingsUseCase {
        return DefaultSettingsUseCase(userRepository: makeUserRepository(),
                                      authRepository: makeAuthRepository())
    }

    // MARK: - View Models
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(authUseCase: makeAuthUseCase())
    }

    func makeSignUpViewModel() -> SignUpViewModel {
        return SignUpViewModel(authUseCase: makeAuthUseCase())
    }
    
    func makeSettingsViewModel() -> SettingsViewModel {
        return SettingsViewModel(settingsUseCase: makeSettingsUseCase())
    }

    // MARK: - View Controller
    func makeLoginViewController() -> LoginViewController {
        return LoginViewController.create(with: makeLoginViewModel())
    }

    func makeSignUpViewController() -> SignUpViewController {
        return SignUpViewController.create(with: makeSignUpViewModel())
    }
    
    func makeSettingsViewController() -> SettingsViewController {
        return SettingsViewController.create(with: makeSettingsViewModel())
    }

    // MARK: - Flow
    func makeSettingsCoordinator(navigationController: UINavigationController,
                                 settingsSceneDIContainer: SettingsSceneDIContainer) -> SettingsCoordinator {
        return DefaultSettingsCoordinator(navigationController: navigationController,
                                          settingsSceneDIContainer: settingsSceneDIContainer)
    }
}
