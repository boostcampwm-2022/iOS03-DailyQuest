//
//  UserInfoView.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import UIKit
import Kingfisher
import SnapKit

final class UserInfoView: UIStackView {
    
    // MARK: - Components
    private lazy var userImage: UIImageView = {
        let userImage = UIImageView()
        userImage.image = UIImage(named: "StatusMax")
        userImage.clipsToBounds = true
        userImage.backgroundColor = .white
        
        return userImage
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.textColor = .white
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        return welcomeLabel
    }()
    
    // MARK: - Methods
    convenience init() {
        self.init(frame: .zero)
        
        axis = .horizontal
        alignment = .center
        spacing = 10
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.layer.cornerRadius = userImage.frame.height / 2
    }
    
    private func configureUI() {
        addArrangedSubview(userImage)
        addArrangedSubview(welcomeLabel)
        
        userImage.snp.makeConstraints { make in
            make.height.equalToSuperview().offset(-40)
            make.width.equalTo(userImage.snp.height)
        }
    }
    
    func setup(with user: User) {
        welcomeLabel.text = user.nickName + "님의 퀘스트"
        userImage.setImage(with: user.profileURL)
    }
}
