//
//  HomeCoordinator.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

import RxSwift

protocol HomeCoordinator: Coordinator {
    func showProfileFlow()
    func showAddQuestFlow()
}

final class DefaultHomeCoordinator: HomeCoordinator {
    private var disposableBag = DisposeBag()
    
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
        
        homeViewController
            .coordinatorPublisher
            .bind(onNext: { [weak self] event in
                switch event {
                    case .showAddQuestsFlow:
                        self?.showAddQuestFlow()
                }
            })
            .disposed(by: disposableBag)
    }
    
    func showProfileFlow() {
        
    }
    
    func showAddQuestFlow() {
        let enrollViewController = homeSceneDIContainer.makeEnrollViewController()
        navigationController.present(enrollViewController, animated: true)
    }
}
