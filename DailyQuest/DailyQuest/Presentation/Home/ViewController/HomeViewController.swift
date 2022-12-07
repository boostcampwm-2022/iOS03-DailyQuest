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

        let output = viewModel.transform(
            input: HomeViewModel.Input(
                viewDidLoad: viewDidLoad,
                itemDidClicked: itemDidClick
            )
        )

        bindToQuestHeaderButton()
        bindToStatusBarProfileButton()
        bindToQuestView(with: output)
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

    private func bindToStatusBarProfileButton() {
        statusView
            .profileButtonDidClick
            .bind(onNext: { [weak self] _ in
            self?.coordinatorPublisher.onNext(.showProfileFlow)
        })
            .disposed(by: disposableBag)
    }
}
