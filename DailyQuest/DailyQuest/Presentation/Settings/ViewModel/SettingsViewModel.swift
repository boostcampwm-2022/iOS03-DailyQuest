//
//  SettingsViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/06.
//

import Foundation

import RxSwift

final class SettingsViewModel {
    private(set) var fields: [CommonField]
    private var navigateField: NavigateField
    
    private let settingsUseCase: SettingsUseCase
    private var disposableBag = DisposeBag()
    
    init(settingsUseCase: SettingsUseCase) {
        self.settingsUseCase = settingsUseCase
        
        let toggleField = ToggleField(viewModel: .init(title: "둘러보기 허용",
                                                       imageName: "person.crop.circle.badge.checkmark",
                                                       settingsUseCase: settingsUseCase))
        let plainField = PlainField(viewModel: .init(title: "앱 버전", info: "1.1", imageName: "exclamationmark.transmission"))
        self.navigateField = NavigateField(viewModel: .init(title: "로그인", imageName: "person.circle.fill", viewType: .login))
        
        self.fields = [
            toggleField,
            plainField,
            navigateField
        ]
    }
    
    struct Input {}
    
    struct Output {
        let loginStatusDidChange: Observable<Void>
    }
    
    func transform() -> Output {
        let loginStatusDidChange = settingsUseCase
            .isLoggedIn()
            .do(onNext: navigateField.toggle(with:))
            .map { _ in Void() }
        
        return Output(loginStatusDidChange: loginStatusDidChange)
    }
    
    func signOut() -> Observable<Bool> {
        return settingsUseCase.signOut()
    }
}
