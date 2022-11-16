//
//  TabCoordinator.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

protocol TabCoordinator: Coordinator {
    var tabBarController: UITabBarController { get set }
}

enum TabBarPage {
    case home
    case browse
    case settings
    
    init?(index: Int) {
        switch index {
            case 0:
                self = .home
            case 1:
                self = .browse
            case 2:
                self = .settings
            default:
                return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
            case .home:
                return "홈"
            case .browse:
                return "둘러보기"
            case .settings:
                return "더보기"
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
            case .home:
                return 0
            case .browse:
                return 1
            case .settings:
                return 2
        }
    }
    
    // Add tab icon value
    
    // Add tab icon selected / deselected color
    
    // etc
}

