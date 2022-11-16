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
    func showAddFriendsFlow()
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
        let addQuestsViewController = AddQuestsViewController()
        navigationController.present(addQuestsViewController, animated: true)
    }
    
    func showAddFriendsFlow() {
        
    }
}
