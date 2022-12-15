//
//  HomeCalendarUseCase.swift
//  DailyQuest
//
//  Created by wickedRun on 2022/12/05.
//

import Foundation

import RxSwift

final class HomeCalendarUseCase: CalendarUseCase {
    private let questsRepository: QuestsRepository
    private let disposeBag = DisposeBag()
    
    let currentMonth = BehaviorSubject<Date?>(value: Date())
    let monthlyCompletions = BehaviorSubject<[[DailyQuestCompletion]]>(value: [[], [], []])
    
    init(questsRepository: QuestsRepository) {
        self.questsRepository = questsRepository
    }
    
    func fetchNextMontlyCompletion() {
        guard let nextMonth = try? currentMonth.value()?.startDayOfNextMonth else { return }
        currentMonth.onNext(nextMonth)
        
        let monthAfterNext = nextMonth.startDayOfNextMonth
        
        fetchAMonthlyCompletion(monthAfterNext)
            .subscribe(onNext: { [weak self] monthlyCompletion in
                guard
                    let self,
                    var monthlyCompletions = try? self.monthlyCompletions.value()
                else {
                    return
                }
                
                monthlyCompletions.removeFirst()
                monthlyCompletions.append(monthlyCompletion)
                
                self.monthlyCompletions.onNext(monthlyCompletions)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchLastMontlyCompletion() {
        guard let lastMonth = try? currentMonth.value()?.startDayOfLastMonth else { return }
        currentMonth.onNext(lastMonth)
        
        let monthBeforeLast = lastMonth.startDayOfLastMonth
        
        fetchAMonthlyCompletion(monthBeforeLast)
            .subscribe(onNext: { [weak self] monthlyCompletion in
                guard
                    let self,
                    var monthlyCompletions = try? self.monthlyCompletions.value()
                else {
                    return
                }
                
                monthlyCompletions.removeLast()
                monthlyCompletions.insert(monthlyCompletion, at: 0)
                
                self.monthlyCompletions.onNext(monthlyCompletions)
            })
            .disposed(by: disposeBag)
    }
    
    func setupMonths() {
        let currentMonth = try? currentMonth.value()
        let startDayOfLastMonth = currentMonth?.startDayOfLastMonth
        let startDayOfCurrentMonth = currentMonth?.startDayOfCurrentMonth
        let startDayOfNextMonth = currentMonth?.startDayOfNextMonth

        let months = [startDayOfLastMonth, startDayOfCurrentMonth, startDayOfNextMonth]
        
        Observable.from(months)
            .concatMap { [weak self] monthDate in
                guard let self else { return Observable<[DailyQuestCompletion]>.empty() }
                
                return self.fetchAMonthlyCompletion(monthDate)
            }
            .toArray()
            .subscribe(onSuccess: { [weak self] completionOfMonths in
                self?.completionOfMonths.onNext(completionOfMonths)
            })
            .disposed(by: disposeBag)
    }
    
    func refreshMontlyCompletion(for date: Date) {
        guard
            let reloadedMonth = date.startDayOfCurrentMonth,
            let reloadedMonthIndex = findIndexAtMonthlyCompletions(for: date)
        else {
            return
        }
        
        fetchAMonthlyCompletion(reloadedMonth)
            .subscribe(onNext: { [weak self] monthlyCompletion in
                guard
                    let self,
                    var monthlyCompletions = try? self.monthlyCompletions.value()
                else {
                    return
                }
                
                monthlyCompletions[reloadedMonthIndex] = monthlyCompletion
                
                self.monthlyCompletions.onNext(monthlyCompletions)
            })
            .disposed(by: disposeBag)
    }
}

extension HomeCalendarUseCase {
    
    private func calculateDailyState(_ quests: [Quest]) -> DailyQuestCompletion.State {
        guard !quests.isEmpty else {
            return .normal
        }
        
        let filteredQuests = quests.filter { !$0.state }
        
        if filteredQuests.isEmpty {
            return .done
        } else {
            return .notDone(filteredQuests.count)
        }
    }
    
    private func findIndexAtMonthlyCompletions(for date: Date) -> Int? {
        guard
            let monthlyCompletions = try? self.monthlyCompletions.value()
        else {
            return nil
        }
        
        return monthlyCompletions.firstIndex(where: { dailyCompletions in
            dailyCompletions.contains { dailyCompletion in
                (dailyCompletion.state != .hidden) && (dailyCompletion.day.startOfDay == date.startOfDay)
            }
        })
    }
    
    private func fetchAMonthlyCompletion(_ month: Date?) -> Observable<[DailyQuestCompletion]> {
        guard let month = month else { return .empty() }
        
        return Observable.from(month.rangeDaysOfMonth)
            .concatMap { [weak self] date -> Observable<DailyQuestCompletion> in
                guard let self else { return Observable.empty() }
                
                return self.questsRepository
                    .fetch(by: date)
                    .asObservable()
                    .map { quests -> DailyQuestCompletion in
                        
                        return DailyQuestCompletion(
                            day: date,
                            state: self.calculateDailyState(quests),
                        )
                    }
            }
            .toArray()
            .map { states in
                let firstWeekStates = month.rangeFromStartWeekdayOfLastMonthToEndDayOfCurrentMonth
                    .map { date -> DailyQuestCompletion in
                        return DailyQuestCompletion(
                            day: date,
                            state: .hidden
                        )
                    }
                
                return firstWeekStates + states
            }
            .asObservable()
    }
}
