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
        case showProfileFlow
    }
    
    var coordinatorPublisher = PublishSubject<Event>()
    
    private var viewModel: HomeViewModel!
    private var disposableBag = DisposeBag()
    private var questViewDelegate: QuestViewDelegate?
    
    private var itemDidLongClick = PublishSubject<Quest>()
    private var itemDidDeleteClicked: PublishSubject<Quest>!
    
    // MARK: - Components
    private lazy var scrollView: UIScrollView = {
        return UIScrollView()
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private lazy var statusView: StatusView = {
        return StatusView()
    }()
    
    private lazy var calendarView: CalendarView = {
        return CalendarView()
    }()
    
    private lazy var questView: QuestView = {
        let questView = QuestView()
        return questView
    }()
    
    private lazy var questViewHeader: QuestViewHeader = {
        return QuestViewHeader()
    }()
    
    private lazy var emptySpace: UIImageView = {
        let emptySpace = UIImageView()
        emptySpace.image = UIImage(named: "NoMoreQuests")
        emptySpace.isHidden = true
        
        return emptySpace
    }()
    
    // MARK: - Life Cycle
    static func create(with viewModel: HomeViewModel) -> HomeViewController {
        let vc = HomeViewController()
        vc.viewModel = viewModel
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questViewDelegate = QuestViewDelegate(header: questViewHeader, type: .home)
        self.itemDidDeleteClicked = questViewDelegate?.itemDidDeleteClicked
        questView.delegate = questViewDelegate
        
        view.backgroundColor = .white
        
        configureUI()
        
        bind()
    }
    
    private func configureUI() {
        stackView.addArrangedSubview(statusView)
        stackView.addArrangedSubview(calendarView)
        stackView.addArrangedSubview(questView)
        stackView.addArrangedSubview(emptySpace)
        
        scrollView.addSubview(stackView)
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        statusView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        calendarView.snp.makeConstraints { make in
            make.height.equalTo(calendarView.snp.width).multipliedBy(1.4)
        }
        
        emptySpace.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(150)
        }
    }
    
    private func bind() {
        let viewDidLoad = Observable.just(Date()).asObservable()
        let itemDidClick = questView.rx.modelSelected(Quest.self).asObservable()
        
        let output = viewModel.transform(
            input: HomeViewModel.Input(
                viewDidLoad: viewDidLoad,
                itemDidClicked: itemDidClick,
                itemDidLongClicked: itemDidLongClick.asObservable(),
                itemDidDeleteClicked: itemDidDeleteClicked,
                profileButtonDidClicked: statusView.profileButtonDidClick,
                dragEventInCalendar: calendarView.dragEvent,
                daySelected: calendarView.daySelected
            ),
            disposeBag: disposableBag
        )
        
        bindToQuestViewHeader(with: output)
        bindToCalendarView(with: output)
        bindToQuestHeaderButton()
        bindToQuestView(with: output)
        bindToStatusView(with: output)
        
    }
    
    private func bindToQuestViewHeader(with output: HomeViewModel.Output) {
        output
            .questHeaderLabel
            .bind(to: questViewHeader.titleLabel.rx.text)
            .disposed(by: disposableBag)
    }
    
    private func bindToCalendarView(with output: HomeViewModel.Output) {
        output
            .calendarDays
            .drive(onNext: { [weak self] dailyQuestCompletions in
                self?.calendarView.apply(
                    calendarDays:
                    dailyQuestCompletions.monthlyCompletions,
                    selected: dailyQuestCompletions.selectedDailyCompletion
                )
            })
            .disposed(by: disposableBag)
        
        output
            .currentMonth
            .compactMap({ $0?.toFormat })
            .bind(to: calendarView.yearMonthLabel.rx.text)
            .disposed(by: disposableBag)
    }
    
    private func bindToQuestHeaderButton() {
        questViewHeader
            .buttonDidClick
            .bind(onNext: { [weak self] _ in
                self?.coordinatorPublisher.onNext(.showAddQuestsFlow)
            })
            .disposed(by: disposableBag)
    }
    
    private func bindToQuestView(with output: HomeViewModel.Output) {
        output
            .data
            .drive(questView.rx.items(cellIdentifier: QuestCell.reuseIdentifier, cellType: QuestCell.self)) { row, item, cell in
                cell.setup(with: item)
                cell.isUserInteractionEnabled = true
                
                let recognizer = UILongPressGestureRecognizer(target: self,action: #selector(self.longPress))
                recognizer.allowableMovement = 0
                cell.layer.setValue(item, forKey: "item")
                cell.addGestureRecognizer(recognizer)
            }
            .disposed(by: disposableBag)
        
        output
            .data
            .map({ !$0.isEmpty })
            .drive(emptySpace.rx.isHidden)
            .disposed(by: disposableBag)
    }
    
    @objc func longPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            guard let quest = sender.view?.layer.value(forKey: "item") as? Quest else { return }
            itemDidLongClick.onNext(quest)
        }
    }
    
    private func bindToStatusView(with output: HomeViewModel.Output) {
        output
            .profileTapResult
            .bind(onNext: needLogIn(result:))
            .disposed(by: disposableBag)
        
        output
            .userData
            .bind(onNext: { [weak self] user in
                guard let self = self else { return }
                self.statusView.userDataFetched.onNext(user)
            })
            .disposed(by: disposableBag)
        
        output.questStatus
            .drive(onNext: self.statusView.questStatus.onNext)
            .disposed(by: disposableBag)
    }
}

extension HomeViewController: Alertable {
    private func needLogIn(result: Bool) {
        if result {
            coordinatorPublisher.onNext(.showProfileFlow)
        } else {
            showAlert(title: "로그인 필요", message: "프로필 화면을 보려면 로그인해주세요.")
        }
    }
}
