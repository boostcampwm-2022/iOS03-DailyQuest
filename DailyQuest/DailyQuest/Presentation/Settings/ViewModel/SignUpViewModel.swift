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
        let submitButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        let buttonEnabled: Driver<Bool>
        let loginResult: Observable<Bool>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let buttonEnabled = Observable
            .combineLatest(input.emailFieldDidEditEvent,
                           input.passwordFieldDidEditEvent) { !$0.isEmpty && !$1.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        let loginResult = input
            .submitButtonDidTapEvent
            .withLatestFrom(Observable
                .combineLatest(input.emailFieldDidEditEvent,
                               input.passwordFieldDidEditEvent))
            .flatMap(authUseCase.signIn(email:password:))
        
        return Output(buttonEnabled: buttonEnabled, loginResult: loginResult)
    }
}

