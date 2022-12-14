//
//  AppAppearance.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

final class AppAppearance {
    static func setupAppearance() {
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().tintColor = .maxGreen
        
        UITableViewCell.appearance().selectionStyle = .none
        UITableView.appearance().separatorStyle = .none
        
        UISwitch.appearance().tintColor = .maxLightGrey
        UISwitch.appearance().onTintColor = .maxYellow
    }
}
