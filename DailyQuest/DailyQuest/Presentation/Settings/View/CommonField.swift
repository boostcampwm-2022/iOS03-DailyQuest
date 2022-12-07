//
//  CommonField.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/23.
//

import UIKit

enum ViewType: String {
    case login = "로그인"
    case logout = "로그아웃"
}

protocol CommonField {
    func register(for tableView: UITableView)
    func dequeue(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    func didSelect() -> ViewType?
}

extension CommonField {
    func didSelect() -> ViewType? {
        return nil
    }
}
