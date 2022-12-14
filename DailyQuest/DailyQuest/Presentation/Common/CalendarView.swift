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
    private var disposeBag = DisposeBag()
    
    private(set) lazy var yearMonthLabel: UILabel = {
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
    
    private(set) lazy var monthCollectionView: UICollectionView = {
        let layout = setupCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.reuseIdentifier)
        return collectionView
    }()
    
    private(set) var dataSource: UICollectionViewDiffableDataSource<Int, DailyQuestCompletion>!
    
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
    enum ScrollDirection {
        case prev
        case next
        case none
    }
    var dragEvent: Observable<ScrollDirection> {
        let willEndDragEvent = monthCollectionView
            .rx
            .willEndDragging
            .map { [weak self] (velocity, cgPointPointer) -> CalendarView.ScrollDirection in
                guard let self else { return .none }
                let bounds = self.monthCollectionView.bounds
                let screenWidth = bounds.width
                let xPos = cgPointPointer.pointee.x

                if xPos == 0 {
                    return .prev
                } else if xPos == screenWidth {
                    return .none
                } else if xPos == screenWidth * 2 {
                    return .next
                } else {
                    return .none
                }
            }
        
        return monthCollectionView
            .rx
            .didEndDecelerating
            .withLatestFrom(willEndDragEvent)
    }
}
