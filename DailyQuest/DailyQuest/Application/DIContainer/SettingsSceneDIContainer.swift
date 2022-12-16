//
//  SettingsSceneDIContainer.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

import DailyContainer

final class SettingsSceneDIContainer {

    init() {
        registerUseCase()
    }

    // MARK: - View Models
    func makeLoginViewModel() -> LoginViewModel {
        @Injected(AuthUseCaseKey.self)
        var authUseCase: AuthUseCase
        
        return LoginViewModel(authUseCase: authUseCase)
    }

    func makeSignUpViewModel() -> SignUpViewModel {
        @Injected(AuthUseCaseKey.self)
        var authUseCase: AuthUseCase
        
        return SignUpViewModel(authUseCase: authUseCase)
    }

    func makeSettingsViewModel() -> SettingsViewModel {
        @Injected(SettingsUseCaseKey.self)
        var settingsUseCase: SettingsUseCase
        
        return SettingsViewModel(settingsUseCase: settingsUseCase)
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

private extension SettingsSceneDIContainer {
    func registerUseCase() {
        Container.shared.register {
            Module(AuthUseCaseKey.self) {
                @Injected(AuthRepositoryKey.self)
                var authRepository: AuthRepository
                
                return DefaultAuthUseCase(authRepository: authRepository)
            }
            
            Module(SettingsUseCaseKey.self) {
                @Injected(UserRepositoryKey.self)
                var userRepository: UserRepository
                
                @Injected(AuthRepositoryKey.self)
                var authRepository: AuthRepository
                
                return DefaultSettingsUseCase(userRepository: userRepository,
                                              authRepository: authRepository)
            }
        }
    }
}
