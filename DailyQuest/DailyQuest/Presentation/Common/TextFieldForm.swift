//
//  TextFieldForm.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/28.
//

import UIKit

final class TextFieldForm: UITextField {
    var textPadding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = UIColor.maxYellow.cgColor
        layer.cornerRadius = 5
        backgroundColor = UIColor(named: "White")
        textColor = .maxViolet
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
