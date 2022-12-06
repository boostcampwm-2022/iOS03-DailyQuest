//
//  SignUpViewController.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/12/06.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class SignUpViewController: UIViewController {
    private var viewModel: LoginViewModel!
    private var disposableBag = DisposeBag()
    
    private lazy var container: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 10
        
        return container
    }()
    
    private lazy var emailField: TextFieldForm = {
        let emailField = TextFieldForm()
        emailField.placeholder = "email"
        
        return emailField
    }()
    
    private lazy var passwordField: TextFieldForm = {
        let passwordField = TextFieldForm()
        passwordField.placeholder = "password"
        
        return passwordField
    }()
    
    private lazy var submitButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .maxYellow
        config.title = "로그인"
        
        return UIButton(configuration: config)
    }()
    
    // MARK: Life Cycle
    static func create(with viewModel: LoginViewModel) -> LoginViewController {
        let vc = LoginViewController()
        vc.setup(with: viewModel)
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        container.addArrangedSubview(emailField)
        container.addArrangedSubview(passwordField)
        container.addArrangedSubview(submitButton)
        
        view.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    private func setup(with authViewModel: LoginViewModel) {
        viewModel = authViewModel
    }
}

extension LoginViewController {
    private func bind() {
        let input = LoginViewModel.Input(
            emailFieldDidEditEvent: emailField.rx.text.orEmpty.asObservable(),
            passwordFieldDidEditEvent: passwordField.rx.text.orEmpty.asObservable(),
            submitButtonDidTapEvent: submitButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposableBag)
        
        output
            .buttonEnabled
            .drive(submitButton.rx.isEnabled)
            .disposed(by: disposableBag)
        
        output
            .loginResult
            .subscribe(onNext: { result in
                print("login result is :::: ", result)
            })
            .disposed(by: disposableBag)
    }
}
