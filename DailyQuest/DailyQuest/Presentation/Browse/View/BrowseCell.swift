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
    static let reuseIdentifier = "BrowseCell"
    
    // MARK: - Components
    private lazy var header: UserInfoView = {
        return UserInfoView()
    }()
    
    private lazy var questTableView: UITableView = {
        let questTableView = UITableView()
        questTableView.backgroundColor = .maxLightBlue
        questTableView.layer.cornerRadius = 15
        
        return questTableView
    }()
    
    // MARK: - Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        questTableView.register(QuestCell.self, forCellReuseIdentifier: QuestCell.reuseIdentifier)
        questTableView.delegate = self
        questTableView.dataSource = self
        
        questTableView.rowHeight = 75 // the cell size
        
        questTableView.allowsSelection = false
        questTableView.sectionHeaderTopPadding = 0
        
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
    
    /**
     인자로 viewModel을 받아, 테이블뷰를 reload합니다.
     
     - Parameters:
        - viewModel: `BrowseItemViewModel` 타입입니다. User의 인스턴스와 Quest 인스턴스의 배열을 가지고 있습니다.
     */
    func setup(with viewModel: BrowseItemViewModel) {
        self.viewModel = viewModel
        header.setup(with: viewModel.user)
        
        questTableView.reloadData()
    }
}

extension BrowseCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
}

extension BrowseCell: UITableViewDataSource {
    /**
     테이블 뷰안에 들어갈 QuestCell의 개수를 구합니다.
     Note. 이 메서드가 최초로 실행되는 시점에는 viewModel이 nil입니다.
     데이터소스를 통해 값이 삽입되는 시점에는 그렇지 않으므로, 예외처리를 통해 해결했습니다.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel?.quests.count else { return 0 }
        return count
    }
    
    /**
     QuestCell을 생성합니다.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = questTableView.dequeueReusableCell(withIdentifier: QuestCell.reuseIdentifier, for: indexPath) as? QuestCell else {
            assertionFailure("Cannot deque reuseable cell.")
            return UITableViewCell()
        }
        cell.setup(with: viewModel.quests[indexPath.row])
        
        return cell
    }
}
