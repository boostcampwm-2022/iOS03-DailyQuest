//
//  BrowseViewController.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/15.
//

import UIKit

import RxSwift
import RxCocoa

final class BrowseViewController: UITableViewController {
    private var viewModel: BrowseViewModel!
    private var disposableBag = DisposeBag()
    
    // MARK: - Life Cycle
    static func create(with viewModel: BrowseViewModel) -> BrowseViewController {
        let view = BrowseViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.register(BrowseCell.self, forCellReuseIdentifier: BrowseCell.reuseIdentifier)
        tableView.rx.setDelegate(self).disposed(by: disposableBag)
        
        bind()
    }
    
    func bind() {
        viewModel
            .data
            .bind(to: tableView.rx.items(cellIdentifier: BrowseCell.reuseIdentifier, cellType: BrowseCell.self)) { row, item, cell in
                cell.setup(with: BrowseItemViewModel(user: item.0, quests: item.1))
                
            }
            .disposed(by: disposableBag)
    }
}

extension BrowseViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0 * CGFloat(viewModel.quests.count)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}
