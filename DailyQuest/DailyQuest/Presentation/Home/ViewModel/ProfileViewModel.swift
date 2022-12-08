//
//  ProfileViewModel.swift
//  DailyQuest
//
//  Created by 이다연 on 2022/12/06.
//

import UIKit
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
        let changeProfileImage: Observable<UIImage?>
    }
    
    struct Output {
        let data: Driver<User>
        let deleteUserResult: Driver<Bool>
        let changeProfileImageResult: Driver<User>
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
        
        let changeProfileImageResult = input.changeProfileImage.flatMap { image in
            
            guard let image = image else {
                return Observable<UIImage?>.just(nil)
            }
            
            guard let data = image.jpegData(compressionQuality: 0.9) else {
                return Observable<UIImage?>.just(nil)
            }
            return self.userUseCase.saveProfileImage(data: data)
                .map{ _ in image }
                .catchAndReturn(nil)
        }.map{ _ in
            Void()
        }.flatMap(userUseCase.fetch)
            .asDriver(onErrorJustReturn: User())
        
        return Output(data: data, deleteUserResult: deleteUserResult, changeProfileImageResult: changeProfileImageResult)
    }
}
