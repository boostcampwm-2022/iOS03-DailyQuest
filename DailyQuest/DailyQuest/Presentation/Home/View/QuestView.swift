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
    private var viewModel: QuestViewModel!
    private var disposableBag = DisposeBag()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        rowHeight = 75
        
        register(QuestCell.self, forCellReuseIdentifier: QuestCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with viewModel: QuestViewModel) {
        self.viewModel = viewModel
        
        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(input: QuestViewModel.Input(viewDidLoad: .just(Date()).asObservable()), disposeBag: disposableBag)
        
        output
            .data
            .drive(rx.items(cellIdentifier: QuestCell.reuseIdentifier, cellType: QuestCell.self)) { row, item, cell in
                cell.setup(with: item)
                cell.backgroundColor = .white
            }
            .disposed(by: disposableBag)
    }
}

/**
 `QuestView`의 델리게이트 역할을 수행할 클래스입니다.
 생성자를 통해 header 정보를 받는 이유는, `func tableView(_:viewForHeaderInSection)`메서드에서 헤더를 지정해주기 때문입니다.
 */
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

