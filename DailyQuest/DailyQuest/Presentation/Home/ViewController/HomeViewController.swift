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

    // MARK: - Life Cycle
    static func create(with viewModel: HomeViewModel) -> HomeViewController {
        let vc = HomeViewController()
        vc.viewModel = viewModel

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        questViewDelegate = QuestViewDelegate(header: questViewHeader)

        questView.delegate = questViewDelegate

        view.backgroundColor = .white

        configureUI()

        bind()
    }

    private func configureUI() {
        stackView.addArrangedSubview(statusView)
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

        statusView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }

        calendarView.snp.makeConstraints { make in
            make.height.equalTo(calendarView.snp.width).multipliedBy(1.4)
        }
    }

    private func bind() {
        let viewDidLoad = Observable.just(Date()).asObservable()
        let itemDidClick = questView.rx.modelSelected(Quest.self).asObservable()
        let dragEventInCalendar = calendarView
            .monthCollectionView
            .rx
            .didEndDecelerating
            .map { [weak self] in
            guard let indexPath = self?.calendarView
                .monthCollectionView
                .indexPathsForVisibleItems
                .first
                else {
                return CalendarView.ScrollDirection.none
            }

            if indexPath.section > 1 {
                return CalendarView.ScrollDirection.next
            } else if indexPath.section < 1 {
                return CalendarView.ScrollDirection.prev
            } else {
                return CalendarView.ScrollDirection.none
            }
        }

        let daySelected = calendarView
            .monthCollectionView
            .rx
            .itemSelected
            .compactMap(calendarView.dataSource.itemIdentifier(for:))
            .map { dailyQuestCompletion in
            dailyQuestCompletion.day
        }
            .asObservable()

        let output = viewModel.transform(
            input: HomeViewModel.Input(
                viewDidLoad: viewDidLoad,
                itemDidClicked: itemDidClick,
                profileButtonDidClicked: statusView.profileButtonDidClick,
                dragEventInCalendar: dragEventInCalendar,
                daySelected: daySelected
            ),
            disposeBag: disposableBag
        )

        bindToCalendarView(with: output)
        bindToQuestHeaderButton()
        bindToQuestView(with: output)
        bindToStatusBarProfileButton(with: output)
        bindToStatusBarProfileButtonImage(with: output)
    }

    private func bindToCalendarView(with output: HomeViewModel.Output) {
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
    
    private func bindViewReload(out){
        
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
        }
            .disposed(by: disposableBag)
    }

    private func bindToStatusBarProfileButton(with output: HomeViewModel.Output) {
        output
            .isLoggedIn
            .bind (onNext: needLogIn(result:))
            .disposed(by: disposableBag)
    }

    private func bindToStatusBarProfileButtonImage(with output: HomeViewModel.Output) {
        output
            .userData
            .bind(onNext: { [weak self] user in
            guard let self = self else { return }
            self.statusView.userDataFetched.onNext(user)
        })
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
