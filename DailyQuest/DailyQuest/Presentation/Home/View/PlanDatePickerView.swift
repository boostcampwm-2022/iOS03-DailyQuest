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
    private var disposableBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .maxViolet
        titleLabel.text = "description"
        
        return titleLabel
    }()
    
    private(set) lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = .init(identifier: "ko_KR")
        
        return datePicker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
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
    
    func title(_ title: String) {
        titleLabel.text = title
    }
}
