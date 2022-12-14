//
//  UserImageView.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/12/08.
//

import UIKit
import SnapKit

final class UserImageView: UIView {
    
    private(set) lazy var userImage: UIImageView = {
        let userImage = UIImageView()
        userImage.image = UIImage(named: "AppIcon")
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 100.0 / 2
        userImage.contentMode = .scaleAspectFill
        return userImage
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(userImage)
    }
    
    private func setupConstraints() {
        userImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
}
