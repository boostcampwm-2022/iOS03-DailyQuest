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
        let changeProfileImage: Observable<UIImage?>
        let changeIntroduceLabel : Observable<String>
    }
    
    struct Output {
        let data: Driver<User>
        let changeProfileImageResult: Driver<User>
        let changeIntroduceLabelResult: Driver<User>
    }
    
    func transform(input: Input) -> Output {
        let data = input
            .viewDidLoad
            .flatMap { _ in
                self.userUseCase.fetch()
            }
            .asDriver(onErrorJustReturn: User())
        
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
                .asObservable()
        }.map{ _ in
            Void()
        }.flatMap(userUseCase.fetch)
            .asDriver(onErrorJustReturn: User())
        
        let changeIntroduceLabelResult = input.changeIntroduceLabel.flatMap { introduce in
            return self.userUseCase.updateIntroduce(introduce: introduce)
                .map{ _ in introduce }
                .catchAndReturn(nil)
                .asObservable()
        }.map{ _ in
            Void()
        }.flatMap(userUseCase.fetch)
            .asDriver(onErrorJustReturn: User())
        
        return Output(data: data, changeProfileImageResult: changeProfileImageResult, changeIntroduceLabelResult: changeIntroduceLabelResult)
    }
}
