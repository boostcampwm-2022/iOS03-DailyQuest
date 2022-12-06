//
//  ProfileViewController.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/12/05.
//

import UIKit
import SnapKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // 이미지뷰 크기를 알기 위해 backgroundColor 넣어둠
    private lazy var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "defaultBackground")
        backgroundImage.contentMode = .scaleToFill
        //backgroundImage.backgroundColor = .red
        return backgroundImage
    }()
    
    private lazy var userImage: UIImageView = {
        let userImage = UIImageView()
        userImage.image = UIImage(named: "AppIcon")
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 100.0 / 2
        userImage.contentMode = .scaleAspectFill
        return userImage
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "name"
        nameLabel.textColor = .maxViolet
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        return nameLabel
    }()
    
    private lazy var introduceLabel: UILabel = {
        let introduceLabel = UILabel()
        introduceLabel.text = "한 줄 소개"
        introduceLabel.textColor = .maxViolet
        introduceLabel.font = UIFont.systemFont(ofSize: 13)
        return introduceLabel
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setTitle("탈퇴하기", for: .normal)
        deleteButton.setTitleColor(.maxViolet, for: .normal)
        deleteButton.backgroundColor = .maxYellow
        deleteButton.layer.cornerRadius = 10
        return deleteButton
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(backgroundImage)
        view.addSubview(userImage)
        view.addSubview(nameLabel)
        view.addSubview(introduceLabel)
        view.addSubview(deleteButton)
        
        backgroundImage.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(300)
        }
        
        userImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.top.equalTo(backgroundImage.snp.bottom).offset(-50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userImage.snp.bottom).offset(5)
        }
        
        introduceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(introduceLabel.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        ProfileViewController().showPreview(.iPhone14Pro)
    }
}
#endif
