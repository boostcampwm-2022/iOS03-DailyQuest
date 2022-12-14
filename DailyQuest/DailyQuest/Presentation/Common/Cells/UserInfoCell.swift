//
//  UserInfoCell.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/14.
//

import UIKit

import SnapKit

final class UserInfoCell: UITableViewCell {
    /// dequeuResusable을 위한 아이덴티파이어입니다.
    static let reuseIdentifier = "UserInfoCell"
    
    // MARK: - Components
    private lazy var container: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.alignment = .center
        container.backgroundColor = .maxLightGrey
        container.spacing = 10
        container.isLayoutMarginsRelativeArrangement = true
        container.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
        container.layer.cornerRadius = 15
        
        return container
    }()
    
    private lazy var userImage: UIImageView = {
        let userImage = UIImageView()
        userImage.image = UIImage(systemName: "heart.fill")
        userImage.clipsToBounds = true
        userImage.backgroundColor = .white
        
        return userImage
    }()
    
    private lazy var userName: UILabel = {
        let userName = UILabel()
        userName.text = " "
        
        return userName
    }()
    
    // MARK: - Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.layer.cornerRadius = userImage.frame.height / 2
    }
    
    private func configureUI() {
        container.addArrangedSubview(userImage)
        container.addArrangedSubview(userName)
        addSubview(container)
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        userImage.snp.makeConstraints { make in
            make.height.equalToSuperview().offset(-40)
            make.width.equalTo(userImage.snp.height)
        }
    }

    func setup(with user: User) {
        userName.text = user.nickName
    }
}
