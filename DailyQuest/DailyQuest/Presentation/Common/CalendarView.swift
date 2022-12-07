//
//  CalendarView.swift
//  DailyQuest
//
//  Created by wickedRun on 2022/11/15.
//

import UIKit
import SnapKit
import RxSwift

final class CalendarView: UIView {
    var viewModel: CalendarViewModel!
    private var disposeBag = DisposeBag()
    
    private lazy var yearMonthLabel: UILabel = {
        let view = UILabel()
        view.adjustsFontSizeToFitWidth = true
        view.font = .systemFont(ofSize: 32, weight: .bold)
        return view
    }()
    
    private lazy var weekdayLabels: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        var calendar = Calendar.current
        calendar.locale = .init(identifier: "ko_KR")
        
        calendar.shortWeekdaySymbols.forEach {
            let label = UILabel()
            label.adjustsFontSizeToFitWidth = true
            label.text = $0
            label.textAlignment = .center
            view.addArrangedSubview(label)
        }
        
        return view
    }()
    
    private lazy var monthCollectionView: UICollectionView = {
        let layout = setupCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.reuseIdentifier)
        return collectionView
    }()
    
    private let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        return formatter
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, DailyQuestCompletion>!
    
    var displayDays: [[DailyQuestCompletion]] = []
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(yearMonthLabel)
        addSubview(weekdayLabels)
        addSubview(monthCollectionView)
    }
    
    private func setupConstraints() {
        yearMonthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        weekdayLabels.snp.makeConstraints { make in
            make.top.equalTo(yearMonthLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(5)
        }
        
        monthCollectionView.snp.makeConstraints { make in
            make.top.equalTo(weekdayLabels.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalToSuperview().inset(5)
        }
    }
    
    private func setupCollectionViewLayout() -> UICollectionViewLayout {
        let itemWidth: CGFloat = 1 / 7
        let groupHeight: CGFloat = 1 / 6
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(itemWidth),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(groupHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 7)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: configuration)
        
        return layout
    }
    
    private func setupDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: monthCollectionView) { collectionView, indexPath, item in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.reuseIdentifier, for: indexPath) as? CalendarCell
            else {
                preconditionFailure()
            }
            
            cell.configure(item)
            
            return cell
        }
    }
}

extension CalendarView {
    
    func bind() {
        let viewDidLoad = Observable.just(()).asObservable()
        let dragEventInCalendar = monthCollectionView
            .rx
            .didEndDecelerating
            .map { [weak self] in
                guard let indexPath = self?.monthCollectionView.indexPathsForVisibleItems.first else {
                    return ScrollDirection.none
                }
                
                if indexPath.section > 1 {
                    return ScrollDirection.next
                } else if indexPath.section < 1 {
                    return ScrollDirection.prev
                } else {
                    return ScrollDirection.none
                }
            }
        
        let output = viewModel.transform(
            input: CalendarViewModel
                .Input(viewDidLoad: viewDidLoad,
                       dragEventInCalendar: dragEventInCalendar),
            disposeBag: disposeBag
        )
        
        output
            .displayDays
            .bind(onNext: { [weak self] dailyQuestCompletions in
                var snapshot = NSDiffableDataSourceSnapshot<Int, DailyQuestCompletion>()
                let allSectionIndex = dailyQuestCompletions.indices.map { Int($0) }
                snapshot.appendSections(allSectionIndex)
                
                allSectionIndex.forEach { index in
                    snapshot.appendItems(dailyQuestCompletions[index], toSection: index)
                }
                
                self?.dataSource.apply(snapshot, animatingDifferences: false)
                self?.monthCollectionView.scrollToItem(at: IndexPath(item: 0, section: 1),
                                                       at: .centeredHorizontally,
                                                       animated: false)
            })
            .disposed(by: disposeBag)
        
        output
            .currentMonth
            .compactMap({ $0 })
            .map(formatDate(with:))
            .bind(to: yearMonthLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func formatDate(with date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    enum ScrollDirection {
        case prev
        case next
        case none
    }
}
