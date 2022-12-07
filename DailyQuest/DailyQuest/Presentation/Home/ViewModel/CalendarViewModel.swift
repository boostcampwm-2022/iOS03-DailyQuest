//
//  CalendarViewModel.swift
//  DailyQuest
//
//  Created by wickedRun on 2022/11/22.
//

import Foundation

import RxSwift
import RxRelay

final class CalendarViewModel {
    
    private var calendarUseCase: CalendarUseCase

    init(calendarUseCase: CalendarUseCase) {
        self.calendarUseCase = calendarUseCase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let dragEventInCalendar: Observable<Bool>
    }
    
    struct Output {
        let currentMonth = BehaviorRelay<Date?>(value: Date())
        let displayDays = BehaviorRelay<[[DailyQuestCompletion]]>(value: [[], [], []])
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.calendarUseCase.setupMonths()
            })
            .disposed(by: disposeBag)
        
        input.dragEventInCalendar
            .subscribe(onNext: { [weak self] direction in
                if direction {
                    self?.calendarUseCase.fetchNextMontlyCompletion()
                } else {
                    self?.calendarUseCase.fetchLastMontlyCompletion()
                }
            })
            .disposed(by: disposeBag)
        
        calendarUseCase.completionOfMonths
            .subscribe(onNext: { monthlyCompletion in
                output.displayDays.accept(monthlyCompletion)
            })
            .disposed(by: disposeBag)
        
        calendarUseCase.currentMonth
            .subscribe(onNext: { month in
                output.currentMonth.accept(month)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
