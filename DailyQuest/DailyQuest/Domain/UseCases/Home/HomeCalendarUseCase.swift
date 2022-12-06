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
    
    var selectedDate: Observable<Date>
    let currentMonth = BehaviorSubject<Date?>(value: Date())
    let completionOfMonths = BehaviorSubject<[MonthlyQuestCompletion]>(value: [])
    
    init(questsRepository: QuestsRepository, selectedDate: Observable<Date>) {
        self.questsRepository = questsRepository
        self.selectedDate = selectedDate
        self.setupMonths()
    }
    
    func fetchNextMontlyCompletion() {
        guard let nextMonth = try? currentMonth.value()?.startDayOfNextMonth else { return }
        currentMonth.onNext(nextMonth)
        
        let monthAfterNext = nextMonth.startDayOfNextMonth
        
        fetchAMontlyCompletion(monthAfterNext)
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
        guard let lastMonth = try? currentMonth.value()?.startDayOfNextMonth else { return }
        currentMonth.onNext(lastMonth)
        
        let monthBeforeLast = lastMonth.startDayOfLastMonth
        
        fetchAMontlyCompletion(monthBeforeLast)
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
}

extension HomeCalendarUseCase {
    
    private func calculateDailyState(_ quests: [Quest]) -> DailyQuestCompletion.State {
        guard !quests.isEmpty else {
            return .normal
        }
        
        let result = quests.reduce(0) { partialResult, quest in
            partialResult + (quest.state ? 1 : 0)
        }
        
        if result == quests.count {
            return .done
        } else {
            return .notDone(result)
        }
    }
    
    private func setupMonths() {
        let currentMonth = try? currentMonth.value()
        let startDayOfLastMonth = currentMonth?.startDayOfLastMonth
        let startDayOfCurrentMonth = currentMonth?.startDayOfCurrentMonth
        let startDayOfNextMonth = currentMonth?.startDayOfNextMonth

        let months = [startDayOfLastMonth, startDayOfCurrentMonth, startDayOfNextMonth]
        
        Observable.from(months)
            .concatMap { [weak self] monthDate in
                guard let self else { return Observable<MonthlyQuestCompletion>.empty() }
                
                return self.fetchAMontlyCompletion(monthDate)
            }
            .toArray()
            .subscribe(onSuccess: { [weak self] completionOfMonths in
                self?.completionOfMonths.onNext(completionOfMonths)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchAMontlyCompletion(_ month: Date?) -> Observable<MonthlyQuestCompletion> {
        guard let month = month else { return .empty() }
        
        return Observable.from(month.rangeDaysOfMonth)
            .concatMap { [weak self] date -> Observable<DailyQuestCompletion> in
                guard let self else { return Observable.empty() }
                
                return self.questsRepository
                    .fetch(by: date)
                    .map { quests -> DailyQuestCompletion in
                        return DailyQuestCompletion(day: date, state: self.calculateDailyState(quests))
                    }
            }
            .toArray()
            .map { states in
                let firstWeekStates = month.rangeFromStartWeekdayOfLastMonthToEndDayOfCurrentMonth
                    .map { date -> DailyQuestCompletion in
                        return DailyQuestCompletion(day: date, state: .hidden)
                    }
                
                return MonthlyQuestCompletion(month: month, states: firstWeekStates + states)
            }
            .asObservable()
    }
}
