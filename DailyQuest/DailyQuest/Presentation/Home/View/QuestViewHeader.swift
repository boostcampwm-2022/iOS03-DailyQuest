//
//  QuestViewHeader.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class QuestViewHeader: UIStackView {
    private var disposableBag = DisposeBag()
    var buttonDidClick = PublishSubject<Void>()
    
    // MARK: - Components
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Today Quest"
        titleLabel.textColor = .maxViolet
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        
        return titleLabel
    }()
    
    private lazy var plusButton: UIButton = {
        var config = UIButton.Configuration.maxStyle()
        let plusButton = UIButton(configuration: config)
                
        return plusButton
    }()
    
    // MARK: - Methods
    convenience init() {
        self.init(frame: .zero)
        
        axis = .horizontal
        alignment = .center
        distribution = .equalSpacing
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        configureUI()
        bind()
    }
    
    private func configureUI() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(plusButton)
    }
    
    /**
     버튼이 클릭되면 `buttonDidClick` subject가 이벤트를 방출합니다.
     눌려졌다는 정보만 있으면 되므로, output type은 Void입니다.
     */
    private func bind() {
        plusButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.buttonDidClick.onNext(())
            })
            .disposed(by: disposableBag)
    }
}
