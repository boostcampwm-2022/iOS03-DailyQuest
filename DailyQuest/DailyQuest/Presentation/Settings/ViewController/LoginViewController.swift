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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
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
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        LoginViewController().showPreview(.iPhone14)
    }
}
#endif
