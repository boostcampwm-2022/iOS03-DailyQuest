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
    private var viewModel: SignUpViewModel!
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
        passwordField.isSecureTextEntry = true
        return passwordField
    }()

    private lazy var passwordConfirmField: TextFieldForm = {
        let passwordConfirmField = TextFieldForm()
        passwordConfirmField.placeholder = "password 확인"
        passwordField.isSecureTextEntry = true
        return passwordConfirmField
    }()

    private lazy var nickNameField: TextFieldForm = {
        let nickNameField = TextFieldForm()
        nickNameField.placeholder = "닉네임"

        return nickNameField
    }()

    private lazy var submitButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .maxYellow
        config.title = "회원가입"

        return UIButton(configuration: config)
    }()

    // MARK: Life Cycle
    static func create(with viewModel: SignUpViewModel) -> SignUpViewController {
        let vc = SignUpViewController()
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

        [emailField,
         passwordField,
         passwordConfirmField,
         nickNameField,
         submitButton].forEach { field in
            container.addArrangedSubview(view)
        }

        view.addSubview(container)

        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }

    private func setup(with authViewModel: SignUpViewModel) {
        viewModel = authViewModel
    }
}

extension SignUpViewController {
    private func bind() {
        let input = SignUpViewModel.Input(
            emailFieldDidEditEvent: emailField.rx.text.orEmpty.asObservable(),
            passwordFieldDidEditEvent: passwordField.rx.text.orEmpty.asObservable(),
            passwordConfirmFieldDidEditEvent: passwordConfirmField.rx.text.orEmpty.asObservable(),
            nickNameFieldDidEditEvent: nickNameField.rx.text.orEmpty.asObservable(),
            submitButtonDidTapEvent: submitButton.rx.tap.asObservable()
        )

        let output = viewModel.transform(input: input, disposeBag: disposableBag)

        output
            .buttonEnabled
            .drive(submitButton.rx.isEnabled)
            .disposed(by: disposableBag)

        output
            .signUpResult
            .subscribe(onNext: { result in
            print("SignUp result is :::: ", result)
        })
            .disposed(by: disposableBag)
    }
}
