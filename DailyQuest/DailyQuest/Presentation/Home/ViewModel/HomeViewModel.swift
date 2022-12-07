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
    private let questUseCase: QuestUseCase
    private var calendarUseCase: CalendarUseCase
    
    init(questUseCase: QuestUseCase, calendarUseCase: CalendarUseCase) {
        self.questUseCase = questUseCase
        self.calendarUseCase = calendarUseCase
    }
    
    struct Input {
        let viewDidLoad: Observable<Date>
        let itemDidClicked: Observable<Quest>
        
        let dragEventInCalendar: Observable<CalendarView.ScrollDirection>
    }
    
    struct Output {
        let data: Driver<[Quest]>
        
        let currentMonth: Observable<Date?>
        let displayDays: Driver<[[DailyQuestCompletion]]>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        let updated = input
            .itemDidClicked
            .compactMap { $0.increaseCount() }
            .flatMap(questUseCase.update(with:))
            .filter({ $0 })
            .map { _ in Date() }
            .asObservable()
        
        let notification = NotificationCenter
            .default
            .rx
            .notification(.updated)
            .compactMap({ $0.object as? Date })
        
        let data = Observable
            .merge(updated, input.viewDidLoad, notification)
            .flatMap(questUseCase.fetch(by:))
            .asDriver(onErrorJustReturn: [])
        
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
        
        let currentMonth = calendarUseCase
            .currentMonth
            .asObserver()
        
        let displayDays = calendarUseCase
            .completionOfMonths
            .asDriver(onErrorJustReturn: [[], [], []])
        
        return Output(data: data,
                      currentMonth: currentMonth,
                      displayDays: displayDays)
    }
}
