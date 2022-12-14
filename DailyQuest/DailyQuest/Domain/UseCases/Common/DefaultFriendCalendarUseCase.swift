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
    let completionOfMonths = BehaviorSubject<[[DailyQuestCompletion]]>(value: [[], [], []])
    let selectedDate = BehaviorSubject<Date>(value: Date())
    
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
                
                return self.fetchAMontlyCompletion(monthDate)
            }
            .toArray()
            .subscribe(onSuccess: { [weak self] completionOfMonths in
                self?.completionOfMonths.onNext(completionOfMonths)
            })
            .disposed(by: disposeBag)
    }
    
    func selectDate(_ date: Date) {
        selectedDate.onNext(date)
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
        guard let lastMonth = try? currentMonth.value()?.startDayOfLastMonth else { return }
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
        
        fetchAMontlyCompletion(reloadMonth)
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
    
    private func fetchAMontlyCompletion(_ month: Date?) -> Observable<[DailyQuestCompletion]> {
        guard let month = month else { return .empty() }
        
        return questsRepository.fetch(by: self.user.uuid, date: month, filter: month)
            .map { dict -> [DailyQuestCompletion] in
                let completionEndDaysOfLastMonth = month.rangeFromStartWeekdayOfLastMonthToEndDayOfCurrentMonth
                    .map { date -> DailyQuestCompletion in
                        return DailyQuestCompletion(
                            day: date,
                            state: .hidden,
                            isSelected: false)
                    }
                
                let completionOfMonths = dict.keys.sorted().map { date -> DailyQuestCompletion in
                    let state = self.calculateDailyState(dict[date] ?? [])
                    let isSelected = (try? self.selectedDate.value().startOfDay == date) ?? false
                    
                    return DailyQuestCompletion(
                        day: date,
                        state: state,
                        isSelected: isSelected)
                }
                
                return completionEndDaysOfLastMonth + completionOfMonths
            }
            .asObservable()
    }
}
