//
//  SettingsCoordinator.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/23.
//

import UIKit

import RxSwift

protocol SettingsCoordinator: Coordinator {
    func showLoginFlow()
}

final class DefaultSettingsCoordinator: SettingsCoordinator {
    private var disposableBag = DisposeBag()
    
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
        let settingsViewController = settingsSceneDIContainer.makeSettingsViewController()
        navigationController.pushViewController(settingsViewController, animated: false)
        
        settingsViewController
            .itemDidClick
            .bind(onNext: { [weak self] event in
                switch event {
                    case .showLoginFlow:
                        self?.showLoginFlow()
                }
            })
            .disposed(by: disposableBag)
    }
    
    func showLoginFlow() {
        let loginViewController = settingsSceneDIContainer.makeLoginViewController()
        navigationController.pushViewController(loginViewController, animated: true)
        
        loginViewController
            .itemDidClick
            .bind(onNext: { [weak self] event in
                switch event {
                    case .showSignUpFlow:
                        self?.showSignUpFlow()
                    case .back:
                        self?.navigationController.popViewController(animated: true)
                }
            })
            .disposed(by: disposableBag)
    }
    
    func showSignUpFlow() {
        let signUpViewController = settingsSceneDIContainer.makeSignUpViewController()
        navigationController.pushViewController(signUpViewController, animated: true)
        
        signUpViewController
            .itemDidClick
            .bind(onNext: { [weak self] event in
                switch event {
                    case .back:
                        self?.navigationController.popToRootViewController(animated: true)
                }
            })
            .disposed(by: disposableBag)
    }
}
