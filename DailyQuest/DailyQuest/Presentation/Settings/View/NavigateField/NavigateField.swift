//
//  NavigateField.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/23.
//

import UIKit

final class NavigateField {
    private var viewModel: NavigateItemViewModel
    
    init(viewModel: NavigateItemViewModel) {
        self.viewModel = viewModel
    }
    
    func toggle(with status: Bool) {
        if status {
            viewModel.viewType = .logout
        } else {
            viewModel.viewType = .login
        }
    }
}

extension NavigateField: CommonField {
    func register(for tableView: UITableView) {
        tableView.register(NavigateCell.self, forCellReuseIdentifier: NavigateCell.reuseIdentifier)
    }
    
    func dequeue(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NavigateCell.reuseIdentifier, for: indexPath) as? NavigateCell else {
            return UITableViewCell()
        }
        cell.setup(with: viewModel)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func didSelect() -> ViewType? {
        return viewModel.viewType
    }
}
