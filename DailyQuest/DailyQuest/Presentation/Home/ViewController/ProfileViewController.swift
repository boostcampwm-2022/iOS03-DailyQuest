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
import RxGesture
import PhotosUI

final class ProfileViewController: UIViewController {
    
    private var viewModel: ProfileViewModel!
    private var disposableBag = DisposeBag()
    
    private let deleteUserButtonDidClicked = PublishSubject<Event>()
    private let changeProfileImage = PublishSubject<UIImage?>()
    
    private lazy var imagePicker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        var imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        return imagePicker
    }()
    
    private lazy var userImageView: UserImageView = {
        return UserImageView()
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "name"
        nameLabel.textColor = .maxViolet
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        return nameLabel
    }()
    
    private lazy var introduceLabel: UILabel = {
        let introduceLabel = UILabel()
        introduceLabel.text = "한 줄 소개"
        introduceLabel.textColor = .maxViolet
        introduceLabel.font = UIFont.systemFont(ofSize: 15)
        return introduceLabel
    }()
    
    private lazy var editIntroduceButton: UIButton = {
        let editIntroduceButton = UIButton()
        editIntroduceButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editIntroduceButton.tintColor = .gray
        return editIntroduceButton
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
        
        view.addSubview(userImageView)
        view.addSubview(nameLabel)
        view.addSubview(introduceLabel)
        view.addSubview(editIntroduceButton)
        view.addSubview(deleteUserButton)
        
        userImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userImageView.snp.bottom).offset(5)
        }
        
        introduceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        editIntroduceButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(introduceLabel.snp.right).offset(5)
        }
        
        deleteUserButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(editIntroduceButton.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
    }
    
    func bind() {
        userImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {
                [weak self] _ in
                guard let self = self else { return }
                self.present(self.imagePicker, animated: true)
            }).disposed(by: disposableBag)
        
        editIntroduceButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {
                [weak self] _ in
                let message = "한줄소개를 작성해주세요."
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    
                   
                }
                alert.addAction(okAction)
                alert.addTextField ()
                self?.present(alert, animated: true, completion: nil)
            }
            )
        
        deleteUserButton.rx.tap
            .subscribe(onNext: {
                self.showAlert()
            }).disposed(by: disposableBag)
        
        let input = ProfileViewModel.Input(viewDidLoad: .just(()).asObservable(), deleteUserButtonDidClicked: deleteUserButtonDidClicked, changeProfileImage: changeProfileImage)
        let output = viewModel.transform(input: input)
        
        output
            .data
            .drive(onNext: { user in
                self.userImageView.userImage.setImage(with: user.profileURL)
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
                    let message = "오류가 발생했습니다. \n 잠시 후 다시 시도해주세요."
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            })
            .disposed(by: disposableBag)
        
        output
            .changeProfileImageResult
            .drive(onNext: { user in
                if user.profileURL != "" {
                    self.userImageView.userImage.setImage(with: user.profileURL)
                } else {
                    self.userImageView.userImage.image = UIImage(named: "AppIcon")
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

extension ProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard error == nil else { return }
                DispatchQueue.main.async {
                    let image = image as? UIImage
                    self?.changeProfileImage.onNext(image)
                }
            }
        }
    }
}


