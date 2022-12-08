//
//  CalendarCell.swift
//  DailyQuest
//
//  Created by wickedRun on 2022/11/14.
//

import UIKit
import SnapKit

final class CalendarCell: UICollectionViewCell {
    
    /// 재사용 식별자
    static let reuseIdentifier = "CalendarCell"
    
    // MARK: - Sub Views
    
    private lazy var circleCheckView: CircleCheckView = {
        let view = CircleCheckView()
        return view
    }()
    
    private lazy var dayLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .gray
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.circleCheckView.layer.borderWidth = 3.0
                self.circleCheckView.layer.borderColor = UIColor.maxDarkYellow.cgColor
            } else {
                self.circleCheckView.layer.borderWidth = 0.0
                self.circleCheckView.layer.borderColor = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupContstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration View
    
    private func addSubviews() {
        self.contentView.addSubview(circleCheckView)
        self.contentView.addSubview(dayLabel)
    }
    
    private func setupContstraints() {
        circleCheckView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.centerX.equalToSuperview().priority(.high)
            make.width.equalTo(self.snp.width).multipliedBy(0.9).inset(5)
            make.height.equalTo(circleCheckView.snp.width).priority(.required)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(circleCheckView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().priority(.high)
        }
    }
    
    // MARK: - Methods
    
    /// CalendarCell의 UI를 변경하는 메소드
    /// - Parameter completion: DailyQuestCompletion
    func configure(_ completion: DailyQuestCompletion) {
        self.isHidden = false

        switch completion.state {
        case .hidden:
            self.isHidden = true
        case .normal:
            self.circleCheckView.setNormal()
        case .notDone(let number):
            self.circleCheckView.setNumber(to: number)
        case .done:
            self.circleCheckView.setDone()
        }
        dayLabel.text = "\(completion.day.day)"
    }
}
