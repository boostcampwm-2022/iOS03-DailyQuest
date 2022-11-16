//
//  UIButton+.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit

extension UIButton.Configuration {
    public static func maxStyle() -> UIButton.Configuration {
        var style = UIButton.Configuration.plain()
        style.image = UIImage(systemName: "plus")
        style.baseForegroundColor = .maxViolet
        style.background.backgroundColor = .maxLightYellow
        style.cornerStyle = .capsule
        
        return style
    }
}
