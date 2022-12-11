//
//  PlainField.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/23.
//

import UIKit

final class PlainField {
    private var viewModel: PlainItemViewModel
    
    init(viewModel: PlainItemViewModel) {
        self.viewModel = viewModel
    }
}

extension PlainField: CommonField {
    func register(for tableView: UITableView) {
        tableView.register(PlainCell.self, forCellReuseIdentifier: PlainCell.reuseIdentifier)
    }
    
    func dequeue(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlainCell.reuseIdentifier, for: indexPath) as? PlainCell else {
            return UITableViewCell()
        }
        cell.setup(with: viewModel)
        
        return cell
    }
    
    func didSelect() -> ViewType? {
        return viewModel.viewType
    }
}
