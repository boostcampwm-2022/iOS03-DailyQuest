//
//  CalendarCell.swift
//  DailyQuest
//
//  Created by wickedRun on 2022/11/14.
//

import UIKit
import SnapKit

class CalendarCell: UICollectionViewCell {
    
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
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(circleCheckView.snp.width)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(circleCheckView.snp.bottom).offset(4)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    /// CalendarCell의 UI를 변경하는 메소드
    /// - parameters:
    ///     - state : CircleCheckView.State
    ///     - day : Int
    func configure(state: CalendarCell.State, day: Int) {
        self.isHidden = false

        switch state {
        case .none:
            self.isHidden = true
        case .normal:
            self.circleCheckView.setNormal()
        case .display(let number):
            self.circleCheckView.setNumber(to: number)
        case .done:
            self.circleCheckView.setDone()
        }
        dayLabel.text = "\(day)"
    }
}

extension CalendarCell {
    
    enum State {
        case none
        case normal
        case display(Int)
        case done
    }
}
