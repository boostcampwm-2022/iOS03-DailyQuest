//
//  CalendarUseCase.swift
//  DailyQuest
//
//  Created by wickedRun on 2022/12/05.
//

import Foundation

import RxSwift

protocol CalendarUseCase {
    
    var currentMonth: BehaviorSubject<Date?> { get }
    var monthlyCompletions: BehaviorSubject<[[DailyQuestCompletion]]> { get }
    
    func fetchNextMontlyCompletion()
    func fetchLastMontlyCompletion()
    func setupMonths()
    func refreshMontlyCompletion(for date: Date)
}
