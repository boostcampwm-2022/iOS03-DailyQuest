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
    
    private lazy var cameraIcon: UIImageView = {
        let cameraIcon = UIImageView()
        cameraIcon.image = UIImage(systemName: "camera.fill")
        cameraIcon.clipsToBounds = true
        cameraIcon.tintColor = .gray
        cameraIcon.contentMode = .scaleAspectFit
        cameraIcon.backgroundColor = .white
        cameraIcon.layer.cornerRadius = 30.0 / 2
        return cameraIcon
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
        addSubview(cameraIcon)
    }
    
    private func setupConstraints() {
        userImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        cameraIcon.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.right.bottom.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.width.height.equalTo(110)
        }
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct UserImageViewPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let view = UserImageView(frame: .zero)
            return view
        }.previewLayout(.fixed(width: 110, height: 110))
    }
}
#endif
