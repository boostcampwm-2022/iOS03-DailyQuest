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
import Lottie

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
    
    private lazy var animationView: LottieAnimationView = {
        let animView = LottieAnimationView(name: "max-loading")
        animView.frame = CGRect(x:0,y:0,width: 400, height: 500)
        animView.contentMode = .scaleAspectFill
        return animView
    }()
    
    // MARK: - Life Cycle
    // static func create(with viewModel: HomeViewModel)
    static func create() -> HomeViewController {
        return HomeViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(animationView)
        configureConstraints()
        //animationView.center = view.center
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        // 애니메이션 실행
        animationView.play{ (finish) in
            self.animationView.removeFromSuperview()
            self.tabBarController?.tabBar.isHidden = false
            self.questViewDelegate = QuestViewDelegate(header: self.questViewHeader)
            self.view.backgroundColor = .white
            self.view.addSubview(self.questView)
            self.questView.delegate = self.questViewDelegate
            self.questView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.bind()
        }
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
    
    private func configureConstraints() {
        animationView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.width.equalTo(400)
            make.height.equalTo(500)
        }
    }
}
