//
//  ToggleField.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/23.
//

import UIKit

final class ToggleField {
    private var viewModel: ToggleItemViewModel
    
    init(viewModel: ToggleItemViewModel) {
        self.viewModel = viewModel
    }
}

extension ToggleField: CommonField {
    func register(for tableView: UITableView) {
        tableView.register(ToggleCell.self, forCellReuseIdentifier: ToggleCell.reuseIdentifier)
    }
    
    func dequeue(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToggleCell.reuseIdentifier, for: indexPath) as? ToggleCell else {
            return UITableViewCell()
        }
        cell.setup(with: viewModel)
        
        return cell
    }
    
    
}
