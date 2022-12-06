//
//  CalendarUseCase.swift
//  DailyQuest
//
//  Created by wickedRun on 2022/12/05.
//

import Foundation

import RxSwift

protocol CalendarUseCase {
    
    var selectedDate: Observable<Date> { get }
    var currentMonth: BehaviorSubject<Date?> { get }
    var completionOfMonths: BehaviorSubject<[MonthlyQuestCompletion]> { get }
    
    func fetchNextMontlyCompletion()
    func fetchLastMontlyCompletion()
}
