//
//  FriendViewController.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/05.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class FriendViewController: UIViewController {
    
    private var viewModel: FriendViewModel!
    private var disposableBag = DisposeBag()
    private var questViewDelegate: QuestViewDelegate?
    
    // MARK: - Components
    private lazy var scrollView: UIScrollView = {
        return UIScrollView()
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private lazy var friendStatusView: FriendStatusView = {
        return FriendStatusView()
    }()
    
    private lazy var calendarView: CalendarView = {
        return CalendarView()
    }()
    
    private lazy var questView: QuestView = {
        let questView = QuestView()
        
        return questView
    }()
    
    private lazy var questViewHeader: QuestViewHeader = {
        let questViewHeader = QuestViewHeader()
        questViewHeader.plusButton.isHidden = true
        
        return questViewHeader
    }()
    
    // MARK: - Life Cycle
    static func create(with viewModel: FriendViewModel) -> FriendViewController {
        let vc = FriendViewController()
        vc.viewModel = viewModel
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questViewDelegate = QuestViewDelegate(header: questViewHeader, type: .friend)
        questView.delegate = questViewDelegate
        
        configureUI()
        
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        stackView.addArrangedSubview(friendStatusView)
        stackView.addArrangedSubview(calendarView)
        stackView.addArrangedSubview(questView)
        
        scrollView.addSubview(stackView)
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        friendStatusView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        calendarView.snp.makeConstraints { make in
            make.height.equalTo(calendarView.snp.width).multipliedBy(1.4)
        }
    }
    
    private func bind() {
        let viewDidLoad = Observable.just(Date()).share().asObservable()
        
        let output = viewModel.transform(
            input: FriendViewModel.Input(
                viewDidLoad: viewDidLoad,
                daySelected: daySelected,
                dragEventInCalendar: dragEventInCalendar
            ),
            disposableBag: disposableBag
        )
        
        bindToQuestViewHeader(with: output)
        bindToStatusView(with: output)
        bindToCalendarView(with: output)
        bindToQuestView(with: output)
    }
    
    private func bindToStatusView(with output: FriendViewModel.Output) {
        output
            .userData
            .map({ $0.nickName })
            .drive(friendStatusView.userNameLabel.rx.text)
            .disposed(by: disposableBag)
        
        output
            .userData
            .map({ $0.introduce })
            .drive(friendStatusView.introduceLabel.rx.text)
            .disposed(by: disposableBag)
        
        output
            .userData
            .drive(onNext: { [weak self] user in
                guard let self = self else { return }
                if user.profileURL != "" {
                    self.friendStatusView.profileImageView.setImage(with: user.profileURL)
                } else {
                    self.friendStatusView.profileImageView.image = UIImage(named: "StatusMax")
                }
            })
            .disposed(by: disposableBag)
    }
    
    private func bindToQuestViewHeader(with output: FriendViewModel.Output) {
        output
            .questHeaderLabel
            .bind(to: questViewHeader.titleLabel.rx.text)
            .disposed(by: disposableBag)
    }
    
    private func bindToCalendarView(with output: FriendViewModel.Output) {
        output
            .displayDays
            .drive(onNext: { [weak self] dailyQuestCompletions in
                var snapshot = NSDiffableDataSourceSnapshot<Int, DailyQuestCompletion>()
                let allSectionIndex = dailyQuestCompletions.indices.map { Int($0) }
                snapshot.appendSections(allSectionIndex)
                
                allSectionIndex.forEach { index in
                    snapshot.appendItems(dailyQuestCompletions[index], toSection: index)
                }
                
                self?.calendarView.dataSource.apply(snapshot, animatingDifferences: false)
                self?.calendarView.monthCollectionView.layoutIfNeeded()
                
                let selectedItem = dailyQuestCompletions
                    .flatMap({ $0 })
                    .first(where: { dailyQuestCompletion in
                        dailyQuestCompletion.isSelected
                    })
                
                if let selectedItem, let indexPath = self?.calendarView.dataSource.indexPath(for: selectedItem) {
                    self?.calendarView.monthCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                }
                
                self?.calendarView.monthCollectionView.scrollToItem(at: IndexPath(item: 0, section: 1),
                                                                    at: .centeredHorizontally,
                                                                    animated: false)
            })
            .disposed(by: disposableBag)
        
        output
            .currentMonth
            .compactMap({ $0?.toFormat })
            .bind(to: calendarView.yearMonthLabel.rx.text)
            .disposed(by: disposableBag)
    }
    
    private func bindToQuestView(with output: FriendViewModel.Output) {
        output
            .data
            .drive(questView.rx.items(cellIdentifier: QuestCell.reuseIdentifier, cellType: QuestCell.self)) { _, item, cell in
                cell.setup(with: item)
            }
            .disposed(by: disposableBag)
    }
}
