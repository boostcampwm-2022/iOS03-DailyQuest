//
//  CustomProgressBar.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/15.
//

import UIKit

final class CustomProgressBar: UIProgressView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach { subview in
            subview.layer.masksToBounds = true
            subview.layer.cornerRadius = 15
        }
    }
}
