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
    private let friendCalendarUseCase: CalendarUseCase
    
    init(user: User,
         friendQuestUseCase: FriendQuestUseCase,
         friendCalendarUseCase: CalendarUseCase)
    {
        self.user = user
        self.friendQuestUseCase = friendQuestUseCase
        self.friendCalendarUseCase = friendCalendarUseCase
    }
    
    struct Input {
        let viewDidLoad: Observable<Date>
        let daySelected: Observable<Date>
        let dragEventInCalendar: Observable<CalendarView.ScrollDirection>
    }
    
    struct Output {
        let questHeaderLabel: Observable<String>
        let userData: Driver<User>
        let data: Driver<[Quest]>
        let currentMonth: Observable<Date?>
        let displayDays: Driver<[[DailyQuestCompletion]]>
    }
    
    func transform(input: Input, disposableBag: DisposeBag) -> Output {
        
        let daySelected = input.daySelected.share()
        
        let data = Observable
            .merge(
                input.viewDidLoad,
                daySelected
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
        
        input
            .dragEventInCalendar
            .subscribe(onNext: { [weak self] direction in
                switch direction {
                case .prev:
                    self?.friendCalendarUseCase.fetchLastMontlyCompletion()
                case .none:
                    break
                case .next:
                    self?.friendCalendarUseCase.fetchNextMontlyCompletion()
                }
            })
            .disposed(by: disposableBag)
        
        let questHeaderLabel = daySelected
            .map(calculateRelative(_:))
            .asObservable()
            .share()
        
        let currentMonth = friendCalendarUseCase
            .currentMonth
            .asObserver()
        
        let displayDays = friendCalendarUseCase
            .completionOfMonths
            .asDriver(onErrorJustReturn: [[], [], []])

        return Output(questHeaderLabel: questHeaderLabel, userData: userData, data: data, currentMonth: currentMonth, displayDays: displayDays)
    }
}

private extension FriendViewModel {
    func fetch(by date: Date) -> Observable<[Quest]> {
        return friendQuestUseCase.fetch(with: user.uuid, by: date)
            .asObservable()
    }
}

extension FriendViewModel {
    func calculateRelative(_ date: Date) -> String {
        let today = Date()
        if today.startOfDay == date.startOfDay {
            return "오늘의 퀘스트"
        } else {
            return "\(date.toFormatMonthDay)의 퀘스트 "
        }
    }
}
