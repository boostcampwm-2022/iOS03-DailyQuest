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
    let completionOfMonths = BehaviorSubject<[[DailyQuestCompletion]]>(value: [[], [], []])
    let selectedDate = BehaviorSubject<Date>(value: Date())
    
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
                    var values = try? self.completionOfMonths.value()
                else {
                    return
                }
                
                values.removeFirst()
                values.append(monthlyCompletion)
                
                self.completionOfMonths.onNext(values)
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
                    var values = try? self.completionOfMonths.value()
                else {
                    return
                }
                
                values.removeLast()
                values.insert(monthlyCompletion, at: 0)
                
                self.completionOfMonths.onNext(values)
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
            let months = try? self.completionOfMonths.value(),
            let index = months.firstIndex(where: { month in
                month.contains { dailyQuestCompletion in
                    (dailyQuestCompletion.state != .hidden)
                    && (dailyQuestCompletion.day.startOfDay == date.startOfDay)
                }
            }),
            let reloadMonth = months[index].last?.day.startDayOfCurrentMonth
        else {
            return
        }
        
        fetchAMonthlyCompletion(reloadedMonth)
            .subscribe(onNext: { [weak self] monthlyCompletion in
                guard
                    let self,
                    var values = try? self.completionOfMonths.value()
                else {
                    return
                }
                
                values[index] = monthlyCompletion
                
                self.completionOfMonths.onNext(values)
            })
            .disposed(by: disposeBag)
    }
    
    func selectDate(_ date: Date) {
        selectedDate.onNext(date)
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
    
    private func fetchAMonthlyCompletion(_ month: Date?) -> Observable<[DailyQuestCompletion]> {
        guard let month = month else { return .empty() }
        
        return Observable.from(month.rangeDaysOfMonth)
            .concatMap { [weak self] date -> Observable<DailyQuestCompletion> in
                guard let self else { return Observable.empty() }
                
                return self.questsRepository
                    .fetch(by: date)
                    .asObservable()
                    .map { quests -> DailyQuestCompletion in
                        let isSelected = (try? self.selectedDate.value().startOfDay == date) ?? false
                        
                        return DailyQuestCompletion(
                            day: date,
                            state: self.calculateDailyState(quests),
                            isSelected: isSelected
                        )
                    }
            }
            .toArray()
            .map { states in
                let firstWeekStates = month.rangeFromStartWeekdayOfLastMonthToEndDayOfCurrentMonth
                    .map { date -> DailyQuestCompletion in
                        return DailyQuestCompletion(day: date, state: .hidden, isSelected: false)
                    }
                
                return firstWeekStates + states
            }
            .asObservable()
    }
}
