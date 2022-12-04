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
        
        /**
         Header에서 버튼이 눌려졌는지를 수신하고 있습니다.
         버튼이 눌러지면 bind내의 클로저가 실행되고, 이는 다시 coordinatorPublisher가 이벤트를 방출하게 합니다.
         이 버튼이 눌러졌을 때에는 퀘스트를 추가하는 화면이 띄워져야 하므로, 이벤트의 종류는 .`showAddQuestsFlow`입니다.
         Note. Combine에서는 `assign(to:)` 오퍼레이터 메서드를 사용하면 이 위치에서 cancellable을 반환하지 않고(rx에서는 disposable)
         이벤트를 연계해줄 수 있지만, rx에서는 동일한 역할을 해주는 오퍼레이터가 없어서 disposableBag에 `Disposable`을 담아주는 것에 유념해주세요.
         */
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
