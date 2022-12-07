//
//  ProfileViewController.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/12/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileViewController: UIViewController {
    
    private var viewModel: ProfileViewModel!
    private var disposableBag = DisposeBag()
    
    private var deleteUserButtonDidClicked = PublishSubject<Event>()
    
    private lazy var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "defaultBackground")
        backgroundImage.contentMode = .scaleToFill
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
    
    private lazy var deleteUserButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setTitle("탈퇴하기", for: .normal)
        deleteButton.setTitleColor(.maxViolet, for: .normal)
        deleteButton.backgroundColor = .maxYellow
        deleteButton.layer.cornerRadius = 10
        return deleteButton
    }()
    
    // MARK: - Life Cycle
    static func create(with viewModel: ProfileViewModel) -> ProfileViewController {
        let vc = ProfileViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(backgroundImage)
        view.addSubview(userImage)
        view.addSubview(nameLabel)
        view.addSubview(introduceLabel)
        view.addSubview(deleteUserButton)
        
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
        
        deleteUserButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(introduceLabel.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
    }
    
    func bind() {
        deleteUserButton.rx.tap//.asDriver().drive(onDisposed:  {
            .subscribe(onNext: {
            print("엄")
            self.showAlert()
        }).disposed(by: disposableBag)
        let input = ProfileViewModel.Input(viewDidLoad: .just(()).asObservable(), deleteUserButtonDidClicked: deleteUserButtonDidClicked)
        let output = viewModel.transform(input: input)
        
        output
            .data
            .drive(onNext: { user in
                self.userImage.setImage(with: user.profileURL)
                self.backgroundImage.setImage(with: user.backgroundImageURL)
                self.nameLabel.text = user.nickName
                self.introduceLabel.text = user.introduce
            })
            .disposed(by: disposableBag)
        output
            .deleteUserResult
            .drive(onNext: { bool in
                if bool {
                    let message = "탈퇴가 완료되었습니다."
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        self.dismiss(animated: true)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let message = "오류가 발생했습니다./n잠시 후 다시 시도해주세요."
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            })
            .disposed(by: disposableBag)
    }
}

extension ProfileViewController {
    func showAlert(preferredStyle: UIAlertController.Style = .alert,
                   completion: (() -> Void)? = nil)
    {
        let title = "탈퇴하기"
        let message = "정말 탈퇴 하시겠습니까?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.deleteUserButtonDidClicked.onNext(.deleteUser)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: completion)
    }
}

extension ProfileViewController {
    enum Event {
        case deleteUser
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
