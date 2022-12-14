//
//  QuantityView.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/30.
//

import UIKit

import RxSwift
import RxCocoa

final class QuantityView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .maxViolet
        titleLabel.text = "목표량"
        
        return titleLabel
    }()
    
    private(set) lazy var quantityField: UITextField = {
        let quantityField = UITextField()
        quantityField.textAlignment = .right
        quantityField.placeholder = "0"
        quantityField.keyboardType = .numberPad
        
        return quantityField
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
        addSubview(quantityField)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(15)
        }
        
        quantityField.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(15)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
    }
}
