//
//  DayNamePickerView.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/30.
//

import UIKit

import RxSwift
import RxCocoa

final class DayNamePickerView: UIStackView {
    private(set) lazy var buttons: [UIButton] = {
        let days: [String] = {
            var calendar = Calendar.current
            calendar.locale = .init(identifier: "ko_KR")
            return calendar.veryShortWeekdaySymbols
        }()
        
        return days.map { day in
            var config = UIButton.Configuration.filled()
            config.title = day
            config.baseBackgroundColor = .maxLightYellow
            config.baseForegroundColor = .maxViolet
            
            let button = UIButton(configuration: config)

            return button
        }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        axis = .horizontal
        spacing = 2
        distribution = .fillEqually
        
        buttons.forEach { button in
            self.addArrangedSubview(button)
        }
    }
}

