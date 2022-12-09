//
//  FriendViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/08.
//

import Foundation

import RxSwift
import RxCocoa

final class FriendViewModel {
    private(set) var user: User
    private let friendQuestUseCase: FriendQuestUseCase
    private let friendCalendarUseCase: FriendCalendarUseCase
    
    init(user: User,
         friendQuestUseCase: FriendQuestUseCase,
         friendCalendarUseCase: FriendCalendarUseCase)
    {
        self.user = user
        self.friendQuestUseCase = friendQuestUseCase
        self.friendCalendarUseCase = friendCalendarUseCase
    }
    
    struct Input {
        let viewDidLoad: Observable<Date>
        let daySelected: Observable<Date>
    }
    
    struct Output {
        let userData: Driver<User>
        let data: Driver<[Quest]>
        let currentMonth: Observable<Date?>
        let displayDays: Driver<[[DailyQuestCompletion]]>
    }
    
    func transform(input: Input, disposableBag: DisposeBag) -> Output {
        
        let data = Observable
            .merge(
                input.viewDidLoad,
                input.daySelected
            )
            .flatMap(fetch(by:))
            .asDriver(onErrorJustReturn: [])
            
        let userData = input.viewDidLoad
            .compactMap({ [weak self] _ in self?.user })
            .asDriver(onErrorJustReturn: User())
        
        input
            .viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.friendCalendarUseCase.setupMonths()
            })
            .disposed(by: disposableBag)
        
        input.daySelected
            .bind { [weak self] date in
                self?.friendCalendarUseCase.selectDate(date)
            }
            .disposed(by: disposableBag)
        
        let currentMonth = friendCalendarUseCase
            .currentMonth
            .asObserver()
        
        let displayDays = friendCalendarUseCase
            .completionOfMonths
            .asDriver(onErrorJustReturn: [[], [], []])

        return Output(userData: userData, data: data, currentMonth: currentMonth, displayDays: displayDays)
    }
}

private extension FriendViewModel {
    func fetch(by date: Date) -> Observable<[Quest]> {
        return friendQuestUseCase.fetch(with: user.uuid, by: date)
            .asObservable()
    }
}
