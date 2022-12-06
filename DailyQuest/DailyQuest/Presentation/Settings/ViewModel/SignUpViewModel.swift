//
//  SignUpViewModel.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/12/06.
//

import Foundation

import RxSwift
import RxCocoa

final class SignUpViewModel {
    private let authUseCase: AuthUseCase
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    struct Input {
        let emailFieldDidEditEvent: Observable<String>
        let passwordFieldDidEditEvent: Observable<String>
        let passwordConfirmFieldDidEditEvent: Observable<String>
        let nickNameFieldDidEditEvent: Observable<String>
        let submitButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        let buttonEnabled: Driver<Bool>
        let signUpResult: Observable<Bool>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let buttonEnabled = Observable
            .combineLatest(input.emailFieldDidEditEvent,
                           input.passwordFieldDidEditEvent,
                           input.passwordConfirmFieldDidEditEvent,
                           input.nickNameFieldDidEditEvent,
                           resultSelector: checkButtonEnble(emailText: passwordText: passwordConfirmText: nickName:))
            .asDriver(onErrorJustReturn: false)
        
        let signUpResult = input
            .submitButtonDidTapEvent
            .withLatestFrom(Observable
                .combineLatest(input.emailFieldDidEditEvent,
                               input.passwordFieldDidEditEvent,
                               input.nickNameFieldDidEditEvent,
                               resultSelector: { ($0, $1, User(nickName: $2)) }))
            .flatMap (authUseCase.signUp(email: password: user:))
        
        return Output(buttonEnabled: buttonEnabled, signUpResult: signUpResult)
    }
    
    func checkEmpty(_ strArray: [String]) -> Bool {
        return !strArray.reduce(false) { $0 || $1.isEmpty }
    }
    
    func checkSame(str1: String, str2: String) -> Bool {
        return str1 == str2
    }
    
    func checkEmail(str: String) -> Bool {
        guard let index = str.firstIndex(of: "@") else { return false }
        return str.startIndex != index && str.endIndex != index
    }
    
    func checkPasswordCount(str: String) -> Bool {
        return str.count >= 6
    }

    func checkButtonEnble(emailText: String,
                          passwordText: String,
                          passwordConfirmText: String,
                          nickName: String) -> Bool {
        return checkEmail(str: emailText) &&
            checkEmpty([emailText, passwordText, passwordConfirmText, nickName]) &&
            checkSame(str1: passwordText, str2: passwordConfirmText) &&
            checkPasswordCount(str: passwordText)
    }
}

