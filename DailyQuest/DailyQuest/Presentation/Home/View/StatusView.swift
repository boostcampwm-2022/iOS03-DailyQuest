//
//  StatusView.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/22.
//

import UIKit

final class StatusView: UIView {
    
    private lazy var iconContainer: UIImageView = {
        let iconContainer = UIImageView()
        
        return iconContainer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
