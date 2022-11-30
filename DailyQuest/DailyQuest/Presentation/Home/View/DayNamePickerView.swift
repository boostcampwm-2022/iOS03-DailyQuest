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
    private var selectedDay = [0: false, 1: false, 2: false, 3: false, 4: false, 5: false, 6: false]
    private(set) var selectedDayObservable = BehaviorRelay<[Int: Bool]>(value: [0: false, 1: false, 2: false, 3: false, 4: false, 5: false, 6: false])
    
    private var disposableBag = DisposeBag()
    
    private lazy var buttons: [UIButton] = {
        let days = ["S", "M", "T", "W", "T", "F", "S"]

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
        
        bind()
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
    
    private func bind() {
        let taps = buttons.enumerated().map { index, button in
            button.rx.tap.map { _ in index }
        }
        
        Observable.from(taps).merge()
            .withUnretained(self)
            .subscribe(onNext: { (owner, value) in
                owner.selectedDay[value]?.toggle()
                owner.selectedDayObservable.accept(owner.selectedDay)
                
                guard let isSelected = owner.selectedDay[value] else { return }
                if isSelected {
                    owner.buttons[value].configuration?.baseBackgroundColor = .maxYellow
                } else {
                    owner.buttons[value].configuration?.baseBackgroundColor = .maxLightYellow
                }
            })
            .disposed(by: disposableBag)
    }
}

