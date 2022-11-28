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
    
    private func nextMonth(date: Date) -> (month: Date, dates: [DisplayDate]) {
        let components = calendar.dateComponents([.year, .month], from: date)
        
        let startOfMonth = calendar.date(from: components)!
        let startOfMonthWeekDay = calendar.dateComponents([.weekday], from: startOfMonth)
        
        let startMonthComp = calendar.dateComponents([.day, .weekday, .weekOfMonth, .month], from: startOfMonth)
        
        let nextMonth = calendar.date(byAdding: .month, value: +1, to: startOfMonth)!
        let endOfMonth = calendar.date(byAdding: .day, value: -1, to: nextMonth)!
        
        let comp2 = calendar.dateComponents([.day, .weekday, .weekOfMonth, .month], from: endOfMonth)

        if startOfMonthWeekDay.weekday == calendar.firstWeekday {
            return (startOfMonth, (startMonthComp.day!...comp2.day!).map { DisplayDate(day: $0, state: .normal) })
        } else {
            let prevMonth = calendar.date(byAdding: .day, value: -1, to: startOfMonth)
            let prevMonthComp = calendar.dateComponents([.weekday, .day], from: prevMonth!)
            var prevMonthStartDayOfEndWeek = prevMonth!
            var prevMonthStartDayOfWeekComp = calendar.dateComponents([.weekday, .day], from: prevMonthStartDayOfEndWeek)
            
            while prevMonthStartDayOfWeekComp.weekday! != calendar.firstWeekday {
                prevMonthStartDayOfEndWeek = calendar.date(byAdding: .day, value: -1, to: prevMonthStartDayOfEndWeek)!
                prevMonthStartDayOfWeekComp = calendar.dateComponents([.weekday, .day], from: prevMonthStartDayOfEndWeek)
            }
            
            return (startOfMonth, (prevMonthStartDayOfWeekComp.day!...prevMonthComp.day!).map { DisplayDate(day: $0, state: .none) } + (startMonthComp.day!...comp2.day!).map { DisplayDate(day: $0, state: .normal) })
        }
    }
    
    private func setupMonths() -> [[DisplayDate]] {
        let prevMonthDay = calendar.date(byAdding: .month, value: -1, to: currentDay)!
        let prevMonth = nextMonth(date: prevMonthDay)
        let currentMonth = nextMonth(date: currentDay)
        let nextMonthDay = calendar.date(byAdding: .month, value: 1, to: currentDay)!
        let nextMonth = nextMonth(date: nextMonthDay)
        
        return [prevMonth.dates, currentMonth.dates, nextMonth.dates]
    }
}

extension CalendarView {
    
    struct DisplayDate {
        let day: Int
        let state: CalendarCell.State
    }
}
