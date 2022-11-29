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
        
        let weekdays = Calendar.current.shortWeekdaySymbols
        
        weekdays.forEach {
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
        collectionView.dataSource = self
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
    
    var itemsBySection = [[CalendarView.DisplayDate]]()
    
    override init(frame: CGRect = .zero) {
        self.currentDay = Date.now
        
        super.init(frame: frame)
        self.itemsBySection = self.setupMonths()
        
        addSubviews()
        setupConstraints()
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
}

extension CalendarView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemsBySection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsBySection[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCell.reuseIdentifier,
            for: indexPath
        ) as? CalendarCell else {
            return UICollectionViewCell(frame: .zero)
        }
        
        let date = itemsBySection[indexPath.section][indexPath.item]
        cell.configure(state: date.state, day: date.day)
        
        return cell
    }
}

extension CalendarView: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let indexPath = monthCollectionView.indexPathsForVisibleItems.first else {
            return
        }
        
        if indexPath.section > 1 {
            currentDay = calendar.date(byAdding: .month, value: 1, to: currentDay)!
            let nextMonthComp = calendar.date(byAdding: .month, value: 1, to: currentDay)!
            let nextMonth = nextMonth(date: nextMonthComp)
            let nextDates = nextMonth.dates
            
            self.itemsBySection.removeFirst()
            self.itemsBySection.append(nextDates)
        } else if indexPath.section < 1 {
            currentDay = calendar.date(byAdding: .month, value: -1, to: currentDay)!
            let nextMonthComp = calendar.date(byAdding: .month, value: -1, to: currentDay)!
            let nextMonth = nextMonth(date: nextMonthComp)
            let nextDates = nextMonth.dates
            
            self.itemsBySection.removeLast()
            self.itemsBySection.insert(nextDates, at: 0)
        }
        
        monthCollectionView.reloadData()
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
}

extension CalendarView {
    
    struct DisplayDate: Hashable {
        let date: Date
        let state: CalendarCell.State
    }
}
