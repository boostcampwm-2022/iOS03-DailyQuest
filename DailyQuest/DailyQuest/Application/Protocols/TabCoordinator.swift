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
    
    var pageTitleValue: String {
        switch self {
            case .home:
                return "홈"
            case .browse:
                return "둘러보기"
            case .settings:
                return "더보기"
        }
    }
    
    var pageOrderNumber: Int {
        switch self {
            case .home:
                return 0
            case .browse:
                return 1
            case .settings:
                return 2
        }
    }
    
    var pageIcon: UIImage? {
        switch self {
            case .home:
                return UIImage(systemName: "house")
            case .browse:
                return UIImage(systemName: "leaf.fill")
            case .settings:
                return UIImage(systemName: "ellipsis")
        }
    }
}

