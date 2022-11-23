//
//  AppDIContainer.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import Foundation

final class AppDIContainer {
    
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        return HomeSceneDIContainer()
    }
    
    func makeBrowseSceneDIContainer() -> BrowseSceneDIContainer {
        return BrowseSceneDIContainer()
    }
    
    func makeSettingsSceneDIContainer() -> SettingsSceneDIContainer {
        return SettingsSceneDIContainer()
    }
}
