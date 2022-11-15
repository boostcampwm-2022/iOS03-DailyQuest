//
//  BrowseCell.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/15.
//

import UIKit

import SnapKit

final class BrowseCell: UITableViewCell {
    var viewModel: BrowseItemViewModel!
    
    /// dequeuResusable을 위한 아이덴티파이어입니다.
    static let reuseIdentifier = "UserInfoCell"
    
    private lazy var questTableView: UITableView = {
        let questTableView = UITableView()
        questTableView.backgroundColor = .maxLightGrey
        questTableView.separatorStyle = .none
        
        return questTableView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        questTableView.register(QuestCell.self, forCellReuseIdentifier: QuestCell.reuseIdentifier)
        questTableView.dataSource = self
        questTableView.delegate = self
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(questTableView)
        
        questTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func setup(with viewModel: BrowseItemViewModel) {
        self.viewModel = viewModel
        
        questTableView.reloadData()
    }
}

extension BrowseCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
}

extension BrowseCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = questTableView.dequeueReusableCell(withIdentifier: QuestCell.reuseIdentifier, for: indexPath) as? QuestCell else {
            assertionFailure("Cannot deque reuseable cell.")
            return UITableViewCell()
        }
        
        cell.setup(with: viewModel.quests[indexPath.row])
        
        return cell
    }
}
