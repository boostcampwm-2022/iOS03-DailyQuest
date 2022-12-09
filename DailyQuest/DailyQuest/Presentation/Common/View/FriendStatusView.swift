//
//  FriendStatusView.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/05.
//

import UIKit

import SnapKit

final class FriendStatusView: UIView {
    
    // MARK: - Components
    private(set) lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "StatusMax")
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        
        return profileImageView
    }()
    
    private lazy var labelContainer: UIStackView = {
        let labelContainer = UIStackView()
        labelContainer.axis = .vertical
        
        return labelContainer
    }()
    
    private(set) lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.text = "User name label님의 Quest"
        
        return userNameLabel
    }()
    
    private(set) lazy var introduceLabel: UILabel = {
        let introduceLabel = UILabel()
        introduceLabel.text = "introduceLabel"
        introduceLabel.textColor = .maxLightGrey
        
        return introduceLabel
    }()
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        labelContainer.addArrangedSubview(userNameLabel)
        labelContainer.addArrangedSubview(introduceLabel)
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(70)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(15)
        }
        
        addSubview(labelContainer)
        labelContainer.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct FriendStatusViewPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let view = FriendStatusView(frame: .zero)
            
            return view
        }
        .previewLayout(.fixed(width: 500, height: 100))
    }
}
#endif
