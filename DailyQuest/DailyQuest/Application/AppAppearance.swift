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
        UITabBar.appearance().tintColor = .maxYellow
        UITableViewCell.appearance().selectionStyle = .none
        UITableView.appearance().separatorStyle = .none
    }
}
