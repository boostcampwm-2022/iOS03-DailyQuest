//
//  AppCoordinator.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

final class AppCoordinator: NSObject, TabCoordinator, UITabBarControllerDelegate {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    let appDIContainer: AppDIContainer
    
    init(tabBarController: UITabBarController,
         appDIContainer: AppDIContainer) {
        self.tabBarController = tabBarController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let pages: [TabBarPage] = [.home, .browse, .settings]
        let controllers: [UINavigationController] = pages.map(getTabController(_:))
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        tabBarController.tabBar.isTranslucent = false
        
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)
        
        navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                     image: page.pageIcon(),
                                                     tag: page.pageOrderNumber())
        
        switch page {
            case .home:
                let homeSceneDIContainer = appDIContainer.makeHomeSceneDIContainer()
                let homeCoordinator = homeSceneDIContainer.makeHomeCoordinator(navigationController: navController,
                                                                               homeSceneDIContainer: homeSceneDIContainer)
                homeCoordinator.start()
                childCoordinators.append(homeCoordinator)
                break
            case .browse:
                let browseSceneDIContainer = appDIContainer.makeBrowseSceneDIContainer()
                let browseCoordinator = browseSceneDIContainer.makeBrowseCoordinator(navigationController: navController,
                                                                                     browseSceneDIContainer: browseSceneDIContainer)
                browseCoordinator.start()
                childCoordinators.append(browseCoordinator)
            case .settings:
                break
        }
        
        return navController
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
    }
}
