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
    
    func bind(with viewModel: DayNamePickerViewModel, disposeBag: DisposeBag) {
        let taps = buttons.enumerated().map { index, button in
            button.rx.tap.map { _ in index }
        }
        
        let input = Observable.from(taps).merge()
        let output = viewModel
            .transform(
                input: DayNamePickerViewModel.Input(buttonDidClicked: input)
            )
        
        output
            .switchButtonStatus
            .subscribe(onNext: { [weak self] index, isSelected in
                guard let isSelected = isSelected else { return }
                if isSelected {
                    self?.buttons[index].configuration?.baseBackgroundColor = .maxYellow
                } else {
                    self?.buttons[index].configuration?.baseBackgroundColor = .maxLightYellow
                }
            })
            .disposed(by: disposeBag)
    }
}

