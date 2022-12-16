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
    typealias DisplayedMonthlyCompletions = (monthlyCompletions: [[DailyQuestCompletion]], selectedDailyCompletion: DailyQuestCompletion?)
    
    private(set) var user: User
    private let friendQuestUseCase: FriendQuestUseCase
    private let friendCalendarUseCase: CalendarUseCase
    private var currentDate = Date()
    
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
        let calendarDays: Driver<DisplayedMonthlyCompletions>
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
            .do(onNext: { [weak self] date in
                self?.currentDate = date
            })
            .map(calculateRelative(_:))
            .asObservable()
            .share()
        
        let currentMonth = friendCalendarUseCase
            .currentMonth
            .asObservable()
        
        let calendarDays = friendCalendarUseCase
            .monthlyCompletions
            .map({ [weak self] monthlyCompletions -> DisplayedMonthlyCompletions in
                let selectedDailyCompletion = self?.findSelectedDailyCompletion(monthlyCompletions)
                
                return (monthlyCompletions, selectedDailyCompletion)
            })
            .asDriver(onErrorJustReturn: (monthlyCompletions: [[], [], []], selectedDailyCompletion: nil))

        return Output(questHeaderLabel: questHeaderLabel,
                      userData: userData,
                      data: data,
                      currentMonth: currentMonth,
                      calendarDays: calendarDays)
    }
}

private extension FriendViewModel {
    func fetch(by date: Date) -> Observable<[Quest]> {
        return friendQuestUseCase.fetch(with: user.uuid, by: date)
            .asObservable()
    }
}

private extension FriendViewModel {
    func calculateRelative(_ date: Date) -> String {
        let today = Date()
        if today.startOfDay == date.startOfDay {
            return "오늘의 퀘스트"
        } else {
            return "\(date.toFormatMonthDay)의 퀘스트 "
        }
    }
}

private extension FriendViewModel {
    func findSelectedDailyCompletion(_ montlyCompletions: [[DailyQuestCompletion]]) -> DailyQuestCompletion? {
        
        return montlyCompletions
            .flatMap { $0 }
            .first { dailyQuestCompletion in
                dailyQuestCompletion.state != .hidden && dailyQuestCompletion.day == self.currentDate.startOfDay
            }
    }
}
