//
//  FriendCalendarUseCase.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/08.
//

import Foundation

import RxSwift

protocol FriendCalendarUseCase {
    var currentMonth: BehaviorSubject<Date?> { get }
    var completionOfMonths: BehaviorSubject<[[DailyQuestCompletion]]> { get }
    var selectedDate: BehaviorSubject<Date> { get }
    
    func setupMonths()
    func selectDate(_ date: Date)
}
