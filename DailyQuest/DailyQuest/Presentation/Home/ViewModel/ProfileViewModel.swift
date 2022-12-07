//
//  ProfileViewModel.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/12/06.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel {
    
    private let userUseCase: UserUseCase
    
    private var disposableBag = DisposeBag()
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let deleteUserButtonDidClicked: Observable<ProfileViewController.Event>
    }
    
    struct Output {
        let data: Driver<User>
        let deleteUserResult: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let data = input
            .viewDidLoad
            .flatMap { _ in
                self.userUseCase.fetch()
            }
            .asDriver(onErrorJustReturn: User())
        
        let deleteUserResult = input.deleteUserButtonDidClicked.flatMap { _ in
            self.userUseCase.delete()
        }
        .asDriver(onErrorJustReturn: false)
        return Output(data: data, deleteUserResult: deleteUserResult)
    }
}
