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
    private var toggleField: ToggleField
    private var plainField: PlainField
    private var navigateField: NavigateField
    
    private let settingsUseCase: SettingsUseCase
    private var disposableBag = DisposeBag()
    
    init(settingsUseCase: SettingsUseCase) {
        self.settingsUseCase = settingsUseCase
        
        self.toggleField = ToggleField(viewModel: .init(title: "둘러보기 허용",
                                                        imageName: "person.crop.circle.badge.checkmark",
                                                        settingsUseCase: settingsUseCase))
        self.plainField = PlainField(viewModel: .init(title: "앱 버전", info: "1.2", imageName: "exclamationmark.transmission", viewType: .version))
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
            .do(onNext: { result in
                if result {
                    let deleteUserField = PlainField(viewModel: .init(title: "탈퇴하기", info: "", imageName: "person.fill.xmark", viewType: .delete))
                    self.fields = [
                        self.toggleField,
                        self.plainField,
                        self.navigateField,
                        deleteUserField
                    ]
                } else {
                    self.fields = [
                        self.toggleField,
                        self.plainField,
                        self.navigateField
                    ]
                }
                self.navigateField.toggle(with: result)
            })
                .map { _ in Void() }
        
        return Output(loginStatusDidChange: loginStatusDidChange)
    }
    
    func signOut() -> Observable<Bool> {
        return settingsUseCase.signOut()
    }
    
    func deleteUser() -> Single<Bool> {
        return settingsUseCase.delete()
    }
}
