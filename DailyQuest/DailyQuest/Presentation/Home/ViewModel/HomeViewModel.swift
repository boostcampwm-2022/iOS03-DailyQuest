//
//  HomeViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/07.
//

import Foundation

import RxSwift
import RxCocoa

final class HomeViewModel {
    private let userUseCase: UserUseCase
    private let questUseCase: QuestUseCase
    private let calendarUseCase: CalendarUseCase
    private var currentDate = Date()
    
    init(userUseCase: UserUseCase, questUseCase: QuestUseCase, calendarUseCase: CalendarUseCase) {
        self.userUseCase = userUseCase
        self.questUseCase = questUseCase
        self.calendarUseCase = calendarUseCase
    }
    
    struct Input {
        let viewDidLoad: Observable<Date>
        let itemDidClicked: Observable<Quest>
        let profileButtonDidClicked: Observable<Void>
        let dragEventInCalendar: Observable<CalendarView.ScrollDirection>
        let daySelected: Observable<Date>
    }
    
    struct Output {
        let data: Driver<[Quest]>
        let userData: Observable<User>
        let questStatus: Driver<(Int, Int)>
        let profileTapResult: Observable<Bool>
        let currentMonth: Observable<Date?>
        let displayDays: Driver<[[DailyQuestCompletion]]>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        let updated = input
            .itemDidClicked
            .compactMap { $0.increaseCount() }
            .flatMap(questUseCase.update(with:))
            .filter({ $0 })
            .compactMap { [weak self] _ in self?.currentDate }
            .share()
            .asObservable()
        
        let updateNotification = NotificationCenter
            .default
            .rx
            .notification(.updated)
        
        let userUpdateNotification = NotificationCenter
            .default
            .rx
            .notification(.userUpdated)
        
        let notification = Observable
            .merge(
                updateNotification,
                userUpdateNotification
            )
            .compactMap({ $0.object as? [Date] })
            .withUnretained(self)
            .compactMap { owner, dates in
                
                let result = dates.filter { date in
                    Calendar.current.isDate(owner.currentDate, inSameDayAs: date)
                }
                
                return !result.isEmpty ? owner.currentDate : nil
            }
        
        let data = Observable
            .merge(
                updated,
                input.viewDidLoad,
                notification,
                input.daySelected
            )
            .do(onNext: { [weak self] date in
                self?.currentDate = date
            })
            .flatMap(questUseCase.fetch(by:))
            .asDriver(onErrorJustReturn: [])
                
        let userNotification = NotificationCenter
            .default
            .rx
            .notification(.userUpdated)
            .map { _ in Date() }
        
        let userData = Observable
            .merge(
                input.viewDidLoad,
                userNotification
            )
            .map { _ in Void() }
            .flatMap(userUseCase.fetch)
        
        let questStatus = Observable
            .merge(
                updated,
                input.viewDidLoad,
                notification)
            .map { _ in Date() }
            .flatMap(questUseCase.fetch(by:))
            .map { quests in
                (quests.reduce(0) { $0 + ($1.state ? 1 : 0) }, quests.count)
            }
            .asDriver(onErrorJustReturn: (0, 0))
        
        let profileTapResult = input
            .profileButtonDidClicked
            .flatMap { [weak self] in
                guard let self = self else { return Observable.just(false) }
                return self.userUseCase.isLoggedIn().take(1)
            }
        
        input
            .viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.calendarUseCase.setupMonths()
            })
            .disposed(by: disposeBag)
        
        input
            .dragEventInCalendar
            .subscribe(onNext: { [weak self] direction in
                switch direction {
                case .prev:
                    self?.calendarUseCase.fetchLastMontlyCompletion()
                case .none:
                    break
                case .next:
                    self?.calendarUseCase.fetchNextMontlyCompletion()
                }
            })
            .disposed(by: disposeBag)
        
        input.daySelected
            .bind { [weak self] date in
                self?.calendarUseCase.selectDate(date)
            }
            .disposed(by: disposeBag)
        
        let currentMonth = calendarUseCase
            .currentMonth
            .asObserver()
        
        let displayDays = calendarUseCase
            .completionOfMonths
            .asDriver(onErrorJustReturn: [[], [], []])
        
        updateNotification
            .subscribe(onNext: { [weak self] date in
                self?.calendarUseCase.setupMonths()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter
            .default
            .rx
            .notification(.questStateChanged)
            .compactMap({ $0.object as? Date })
            .subscribe(onNext: { [weak self] date in
                self?.calendarUseCase.refreshMontlyCompletion(for: date)
            })
            .disposed(by: disposeBag)
        
        return Output(data: data,
                      userData: userData,
                      questStatus: questStatus,
                      profileTapResult: profileTapResult,
                      currentMonth: currentMonth,
                      displayDays: displayDays)
    }
}
