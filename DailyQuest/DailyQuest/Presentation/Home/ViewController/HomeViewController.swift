//
//  HomeViewController.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class HomeViewController: UIViewController {
    enum Event {
        case showAddQuestsFlow
    }
    
    var coordinatorPublisher = PublishSubject<Event>()
    
    private var disposableBag = DisposeBag()
    private var questViewDelegate: QuestViewDelegate?
    
    private lazy var questView: QuestView = {
        let questView = QuestView()
        questView.setup(with: QuestViewModel())
        
        return questView
    }()
    
    private lazy var questViewHeader: QuestViewHeader = {
        return QuestViewHeader()
    }()
    
    // MARK: - Life Cycle
    // static func create(with viewModel: HomeViewModel)
    static func create() -> HomeViewController {
        return HomeViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questViewDelegate = QuestViewDelegate(header: questViewHeader)
        
        view.backgroundColor = .white
        
        view.addSubview(questView)
        
        questView.delegate = questViewDelegate
        questView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bind()
    }
    
    private func bind() {
        questViewHeader
            .buttonDidClick
            .bind(onNext: { [weak self] _ in
                self?.coordinatorPublisher.onNext(.showAddQuestsFlow)
            })
            .disposed(by: disposableBag)
    }
}
