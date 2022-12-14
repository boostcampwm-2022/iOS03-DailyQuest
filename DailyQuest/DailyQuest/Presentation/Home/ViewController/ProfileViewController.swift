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
    
    private let changeProfileImage = PublishSubject<UIImage?>()
    private let changeIntroduceLabel = PublishSubject<String>()
    
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
    
    private lazy var editProfileImageButton: UIButton = {
        let editProfileImageButton = UIButton()
        editProfileImageButton.setTitle("프로필 이미지 변경", for: .normal)
        editProfileImageButton.setTitleColor(.maxViolet, for: .normal)
        editProfileImageButton.backgroundColor = .maxYellow
        editProfileImageButton.layer.cornerRadius = 10
        return editProfileImageButton
    }()
    
    
    private lazy var editIntroduceLabel: UIButton = {
        let editIntroduceLabel = UIButton()
        editIntroduceLabel.setTitle("한 줄 소개 변경", for: .normal)
        editIntroduceLabel.setTitleColor(.maxViolet, for: .normal)
        editIntroduceLabel.backgroundColor = .maxYellow
        editIntroduceLabel.layer.cornerRadius = 10
        return editIntroduceLabel
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
        view.addSubview(editProfileImageButton)
        view.addSubview(editIntroduceLabel)
        
        userImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userImageView.snp.bottom).offset(60)
        }
        
        introduceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        editProfileImageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(introduceLabel.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
        
        editIntroduceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(editProfileImageButton.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
    }
    
    func bind() {
        
        editProfileImageButton.rx.tap
            .subscribe(onNext: {
                [weak self] _ in
                guard let self = self else { return }
                self.present(self.imagePicker, animated: true)
            }).disposed(by: disposableBag)
        
        editIntroduceLabel.rx.tap
            .subscribe(onNext: {
                [weak self] _ in
                self?.showIntroduceAlert()
            })
            .disposed(by: disposableBag)
        
        let input = ProfileViewModel.Input(viewDidLoad: .just(()).asObservable(),changeProfileImage: changeProfileImage, changeIntroduceLabel: changeIntroduceLabel)
        let output = viewModel.transform(input: input)
        
        output
            .data
            .drive(onNext: { user in
                self.userImageView.userImage.setImage(with: user.profileURL)
                self.nameLabel.text = user.nickName
                self.introduceLabel.text = user.introduce
                if self.introduceLabel.text == "" {
                    self.setDefaultIntroduce()
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
        
        output
            .changeIntroduceLabelResult
            .drive(onNext: { user in
                self.introduceLabel.text = user.introduce
                if self.introduceLabel.text == "" {
                    self.setDefaultIntroduce()
                } else {
                    self.introduceLabel.textColor = .maxViolet
                }
            })
            .disposed(by: disposableBag)
    }
    
    private func setDefaultIntroduce() {
        self.introduceLabel.text = "한 줄 소개를 작성해주세요."
        self.introduceLabel.textColor = .maxLightGrey
    }
    
    private func showIntroduceAlert(preferredStyle: UIAlertController.Style = .alert,
                                    completion: (() -> Void)? = nil) {
        let message = "한줄소개를 작성해주세요."
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            let text = alert.textFields?[0].text
            self?.changeIntroduceLabel.onNext(text ?? "")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        alert.addTextField ()
        self.present(alert, animated: true, completion: nil)
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


