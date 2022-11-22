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
        
        var weekdays = self.calendar.shortWeekdaySymbols
        let sunday = weekdays.remove(at: 0)
        weekdays = weekdays + [sunday]
        
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
    private let calendar: Calendar
    private var currentDay: Date {
        didSet {
            yearMonthLabel.text = dateFormatter.string(from: currentDay)
        }
    }
    
    var itemsBySection = [[CalendarView.DisplayDate]]()
    
    override init(frame: CGRect = .zero) {
        var newCalendar = Calendar.current
        newCalendar.timeZone = .init(identifier: "UTC") ?? .current
        newCalendar.firstWeekday = 2
        self.calendar = newCalendar
        self.currentDay = Date.now
        
        super.init(frame: frame)
        self.itemsBySection = self.setupMonths()
        
        addSubviews()
        setupConstraints()
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
            make.top.horizontalEdges.equalToSuperview().inset(5)
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
extension CalendarView {
    
    struct DisplayDate {
        let day: Int
        let state: CalendarCell.State
    }
}
