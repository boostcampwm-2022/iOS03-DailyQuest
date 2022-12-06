//
//  CalendarView.swift
//  DailyQuest
//
//  Created by wickedRun on 2022/11/15.
//

import UIKit
import SnapKit

class CalendarView: UIView {
    
    lazy var yearMonthLabel: UILabel = {
        let view = UILabel()
        view.adjustsFontSizeToFitWidth = true
        view.font = .systemFont(ofSize: 32, weight: .bold)
        view.text = dateFormatter.string(from: currentDay)
        return view
    }()
    
    lazy var weekdayLabels: UIStackView = {
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

    lazy var monthCollectionView: UICollectionView = {
        let layout = setupCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.reuseIdentifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    private let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        return formatter
    }()
    
    private var currentDay: Date {
        didSet {
            yearMonthLabel.text = dateFormatter.string(from: currentDay)
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Int, DisplayDate>!
    
    var itemsBySection: [[CalendarView.DisplayDate]] = [[], [], []]
    
    override init(frame: CGRect = .zero) {
        self.currentDay = Date.now
        
        super.init(frame: frame)
        self.itemsBySection = self.setupMonths()
        
        addSubviews()
        setupConstraints()
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        monthCollectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .centeredHorizontally, animated: false)
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
            
            cell.configure(state: item.state, day: item.date.day)
            
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, DisplayDate>()
        itemsBySection.indices.forEach { index in
            snapshot.appendSections([index])
            snapshot.appendItems(itemsBySection[index], toSection: index)
        }
        dataSource.apply(snapshot)
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DisplayDate>()
        let allSectionIndex = itemsBySection.indices.map { Int($0) }
        snapshot.appendSections(allSectionIndex)
        allSectionIndex.forEach { index in
            snapshot.appendItems(itemsBySection[index], toSection: index)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension CalendarView: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let indexPath = monthCollectionView.indexPathsForVisibleItems.first else {
            return
        }
        
        if indexPath.section > 1 {
            nextMonth()
        } else if indexPath.section < 1 {
            lastMonth()
        } else {
            return
        }
        
        applySnapshot()
        monthCollectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .centeredHorizontally, animated: false)
    }
    
    private func fetchDisplayDaysOfMonth(for date: Date?) -> [DisplayDate] {
        guard let date else { return [] }
        
        return date.rangeFromStartWeekdayOfLastMonthToEndDayOfCurrentMonth.map { DisplayDate(date: $0, state: .none) } + date.rangeDaysOfMonth.map { DisplayDate(date: $0, state: .normal) }
    }
    
    private func setupMonths() -> [[DisplayDate]] {
        let startDayOfPrevMonth = currentDay.startDayOfLastMonth
        let startDayOfNextMonth = currentDay.startDayOfNextMonth
        
        return [startDayOfPrevMonth, currentDay, startDayOfNextMonth].map(fetchDisplayDaysOfMonth(for:))
    }
    
    private func nextMonth() {
        currentDay = currentDay.nextMonthOfCurrentDay!
        let monthAfterNext = currentDay.nextMonthOfCurrentDay!
        let monthAfterNextDisplayDays = fetchDisplayDaysOfMonth(for: monthAfterNext)
        
        self.itemsBySection.removeFirst()
        self.itemsBySection.append(monthAfterNextDisplayDays)
    }
    
    private func lastMonth() {
        currentDay = currentDay.lastMonthOfCurrentDay!
        let monthBeforeLast = currentDay.lastMonthOfCurrentDay!
        let monthBeforeLastDisplayDays = fetchDisplayDaysOfMonth(for: monthBeforeLast)
        
        self.itemsBySection.removeLast()
        self.itemsBySection.insert(monthBeforeLastDisplayDays, at: 0)
    }
}

extension CalendarView {
    
    struct DisplayDate: Hashable {
        let date: Date
        let state: CalendarCell.State
    }
}