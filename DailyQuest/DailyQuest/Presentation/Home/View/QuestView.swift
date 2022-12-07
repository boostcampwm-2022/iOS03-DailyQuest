//
//  QuestView.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

import RxSwift
import RxCocoa

final class QuestView: UITableView {
    private var disposableBag = DisposeBag()
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let number = numberOfRows(inSection: 0)
        return CGSize(width: contentSize.width, height: CGFloat(75*number + 75))
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        rowHeight = 75
        sectionHeaderTopPadding = 0
        isScrollEnabled = false
        
        register(QuestCell.self, forCellReuseIdentifier: QuestCell.reuseIdentifier)
    }
}

final class QuestViewDelegate: NSObject, UITableViewDelegate {
    private let header: QuestViewHeader
    
    init(header: QuestViewHeader) {
        self.header = header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
    
    deinit {
        print("deinit")
    }
}

