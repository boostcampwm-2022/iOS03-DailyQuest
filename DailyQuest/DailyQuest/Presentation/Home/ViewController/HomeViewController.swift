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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private lazy var questView: QuestView = {
        let questView = QuestView()
        
        return questView
    }()
    
    private lazy var questViewHeader: QuestViewHeader = {
        return QuestViewHeader()
    }()
    
    private lazy var followingView: FollowingView = {
        return FollowingView()
    }()
    
    // MARK: - Life Cycle
    static func create(with viewModel: QuestViewModel) -> HomeViewController {
        let vc = HomeViewController()
        vc.setup(questViewModel: viewModel)
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questViewDelegate = QuestViewDelegate(header: questViewHeader)
        
        questView.delegate = questViewDelegate

        view.backgroundColor = .white
        
        stackView.addArrangedSubview(followingView)
        stackView.addArrangedSubview(questView)
        
        
        view.addSubview(stackView)
        

        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        followingView.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(125)
        }
        
        bind()
    }
    
    private func bind() {
        questView.bind()
        
        questViewHeader
            .buttonDidClick
            .bind(onNext: { [weak self] _ in
                self?.coordinatorPublisher.onNext(.showAddQuestsFlow)
            })
            .disposed(by: disposableBag)
    }
    
    private func setup(questViewModel: QuestViewModel) {
        questView.setup(with: questViewModel)
    }
    
    private func configureFollowingView() {
        
    }

}
