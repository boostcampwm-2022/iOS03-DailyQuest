//
//  BrowseCoordinator.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

import RxSwift

protocol BrowseCoordinator: Coordinator {
    func showFriendFlow(with user: User)
}

final class DefaultBrowseCoordinator: BrowseCoordinator {
    private var disposableBag = DisposeBag()
    
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
        navigationController.isNavigationBarHidden = true
        
        browseViewController
            .coordinatorPublisher
            .subscribe(onNext: showFriendFlow(with:))
            .disposed(by: disposableBag)
    }
    
    func showFriendFlow(with user: User) {
        let friendViewController = browseSceneDIContainer.makeFriendViewController(with: user)
        navigationController.present(friendViewController, animated: true)
    }
}

