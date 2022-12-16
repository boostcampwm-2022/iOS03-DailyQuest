//
//  DefaultFriendCalendarUseCase.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/08.
//

import Foundation

import RxSwift

import RxSwift

final class DefaultFriendCalendarUseCase: CalendarUseCase {
    private let user: User
    private let questsRepository: QuestsRepository
    private let disposeBag = DisposeBag()
    
    let currentMonth = BehaviorSubject<Date?>(value: Date())
    let monthlyCompletions = BehaviorSubject<[[DailyQuestCompletion]]>(value: [[], [], []])
    
    init(user: User, questsRepository: QuestsRepository) {
        self.user = user
        self.questsRepository = questsRepository
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
            .subscribe(onSuccess: { [weak self] fetchedMonthlyCompletions in
                self?.monthlyCompletions.onNext(fetchedMonthlyCompletions)
            })
            .disposed(by: disposeBag)
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

extension DefaultFriendCalendarUseCase {
    
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
        
        return questsRepository
            .fetch(by: self.user.uuid, date: month, filter: month)
            .map { [weak self] dict -> [DailyQuestCompletion] in
                guard let self else { return [] }
                let endWeekOfLastMonthCompletion = month.rangeFromStartWeekdayOfLastMonthToEndDayOfCurrentMonth
                    .map { date -> DailyQuestCompletion in
                        return DailyQuestCompletion(
                            day: date,
                            state: .hidden
                        )
                    }
                
                let fetchedMonthCompletion = dict.keys.sorted().map { date -> DailyQuestCompletion in
                    let state = self.calculateDailyState(dict[date] ?? [])
                    
                    return DailyQuestCompletion(
                        day: date,
                        state: state
                    )
                }
                
                return endWeekOfLastMonthCompletion + fetchedMonthCompletion
            }
            .asObservable()
    }
}
