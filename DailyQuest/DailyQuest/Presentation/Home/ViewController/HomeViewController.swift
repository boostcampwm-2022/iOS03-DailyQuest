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
        // case showProfileFlow
        // case showAddFriendsFlow
    }
    
    // MARK: - Properies
    var coordinatorPublisher = PublishSubject<Event>()
    
    private var disposableBag = DisposeBag()
    private var questViewDelegate: QuestViewDelegate?
    
    // MARK: - Components
    private lazy var firstPartView: UIView = {
        let firstPartView = UIView()
        firstPartView.backgroundColor = .maxYellow
        return firstPartView
    }()
    
    private lazy var secondPartView: UIView = {
        let secondPartView = UIView()
        secondPartView.backgroundColor = .maxLightGrey
        return secondPartView
    }()
    
    private lazy var thridPartView: UIView = {
        let thridPartView = UIView()
        thridPartView.backgroundColor = .maxYellow
        return thridPartView
    }()
    
    private lazy var questView: QuestView = {
        let questView = QuestView()
        questView.setup(with: QuestViewModel())
        
        return questView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
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
        
        questView.delegate = questViewDelegate
        
        configureUI()
        bind()
    }
    
    private func bind() {
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
    
    private func configureUI() {
        stackView.addArrangedSubview(firstPartView)
        stackView.addArrangedSubview(secondPartView)
        stackView.addArrangedSubview(thridPartView)
        stackView.addArrangedSubview(questView)
        
        scrollView.addSubview(stackView)
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        firstPartView.snp.makeConstraints { make in
            make.width.equalTo(stackView)
            make.height.equalTo(100)
        }
        
        secondPartView.snp.makeConstraints { make in
            make.width.equalTo(stackView)
            make.height.equalTo(400)
        }
        
        thridPartView.snp.makeConstraints { make in
            make.width.equalTo(stackView)
            make.height.equalTo(100)
        }
        
        questView.snp.makeConstraints { make in
            make.width.equalTo(stackView)
            make.height.equalTo(400)
        }
    }
}
