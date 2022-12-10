//
//  LoginViewController.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/28.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class LoginViewController: UIViewController {
    enum Event {
        case showSignUpFlow
        case back
    }
    
    private var viewModel: LoginViewModel!
    private var disposableBag = DisposeBag()
    
    var itemDidClick = PublishSubject<Event>()
    
    private lazy var container: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 10
        
        return container
    }()
    
    private lazy var emailField: TextFieldForm = {
        let emailField = TextFieldForm()
        emailField.placeholder = "email"
        emailField.autocapitalizationType = .none
        return emailField
    }()
    
    private lazy var passwordField: TextFieldForm = {
        let passwordField = TextFieldForm()
        passwordField.placeholder = "password"
        passwordField.isSecureTextEntry = true
        return passwordField
    }()
    
    private lazy var submitButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .maxYellow
        config.title = "로그인"
        emailField.autocapitalizationType = .none
        return UIButton(configuration: config)
    }()
    
    private lazy var signUpButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .gray
        config.title = "회원가입"
        config.buttonSize = .small
        return UIButton(configuration: config)
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        // Create an indicator.
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .maxDarkYellow
        
        let transfrom = CGAffineTransform.init(scaleX: 2, y: 2)
        activityIndicator.transform = transfrom
    
        return activityIndicator
    }()
    
    // MARK: Life Cycle
    static func create(with viewModel: LoginViewModel) -> LoginViewController {
        let vc = LoginViewController()
        vc.setup(with: viewModel)
        
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
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
        container.addArrangedSubview(signUpButton)
        
        view.addSubview(container)
        view.addSubview(activityIndicator)
        
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setup(with authViewModel: LoginViewModel) {
        viewModel = authViewModel
    }
}

extension LoginViewController {
    private func bind() {
        signUpButton.rx.tap.bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.itemDidClick.onNext(.showSignUpFlow)
        }).disposed(by: disposableBag)
        
        let submitButtonDidTapEvent = submitButton.rx.tap
            .asObservable()
            .do(onNext: { [weak self] _ in
            self?.activityIndicator.startAnimating()
        })
        
        let input = LoginViewModel.Input(
            emailFieldDidEditEvent: emailField.rx.text.orEmpty.asObservable(),
            passwordFieldDidEditEvent: passwordField.rx.text.orEmpty.asObservable(),
            submitButtonDidTapEvent: submitButtonDidTapEvent
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposableBag)
        
        output
            .buttonEnabled
            .drive(submitButton.rx.isEnabled)
            .disposed(by: disposableBag)
        
        output
            .loginResult
            .bind(onNext: analyse(result:))
            .disposed(by: disposableBag)
    }
}

extension LoginViewController: Alertable {
    private func analyse(result: Bool) {
        activityIndicator.stopAnimating()
        if result {
            itemDidClick.onNext(.back)
        } else {
            showAlert(title: "로그인 실패", message: "이메일과 비밀번호를 확인해주세요.")
        }
    }
}
