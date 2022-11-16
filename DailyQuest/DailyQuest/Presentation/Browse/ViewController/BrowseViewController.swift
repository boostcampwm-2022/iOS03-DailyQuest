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
        
        configure()
        bind()
    }
    
    /**
     table view의 기본 정보를 설정합니다.
     */
    private func configure() {
        // 델리게이트와 데이터소스를 rx로 재설정합니다.
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rx.setDelegate(self).disposed(by: disposableBag)
        
        // BrowseCell을 등록합니다.
        tableView.register(BrowseCell.self, forCellReuseIdentifier: BrowseCell.reuseIdentifier)
    }
    
    private func bind() {
        viewModel
            .data
            .bind(to: tableView.rx.items(cellIdentifier: BrowseCell.reuseIdentifier, cellType: BrowseCell.self)) { row, item, cell in
                cell.setup(with: BrowseItemViewModel(user: item.0, quests: item.1))
            }
            .disposed(by: disposableBag)
    }
}

extension BrowseViewController {
    /**
     하나의 BrowseCell의 크기를 결정합니다. BrowseCell내의 QuestCell의 개수만큼 크기가 늘어납니다.
     +20은 margins으로 인해 추가된 값입니다.
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (75.0 * CGFloat(viewModel.cellCount[indexPath.row])) + 20 + 75
    }
    
    /**
     viewModel에서 총 몇개의 BrowseCell을 만들어야하는지 결정합니다.
     viewModel에는 UseCase를 통해 들어온 (User, [Quest]) 데이터에서 퀘스트의 **길이** 정보를 담는 프로퍼티(정ㅅ배열)가 있어야 합니다.
     Note. 여기에서는 Quest 정보 자체가 필요하진 않습니다. 해당 배열의 아이템들은 위에서 사용할, BrowseCell의 크기를 결정하고,
     배열 자체의 길이는 이 메서드의 결과를 결정합니다.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellCount.count
    }
}
