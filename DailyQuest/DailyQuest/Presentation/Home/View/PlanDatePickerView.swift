//
//  PlanDatePickerView.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/30.
//

import UIKit

import RxSwift
import SnapKit

final class PlanDatePickerView: UIView {
    private(set) var date = PublishSubject<Date>()
    private var disposableBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .maxViolet
        titleLabel.text = "description"
        
        return titleLabel
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        return datePicker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .maxLightYellow
        layer.cornerRadius = 15
        
        addSubview(titleLabel)
        addSubview(datePicker)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(15)
        }
        
        datePicker.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
    private func bind() {
        datePicker
            .rx
            .controlEvent(.valueChanged)
            .withLatestFrom(datePicker.rx.date)
            .bind(to: date)
            .disposed(by: disposableBag)
    }
}
