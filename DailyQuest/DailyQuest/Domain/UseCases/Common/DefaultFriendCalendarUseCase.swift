//
//  DefaultFriendCalendarUseCase.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/08.
//

import Foundation

import RxSwift

import RxSwift

final class DefaultFriendCalendarUseCase: FriendCalendarUseCase {
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
        let startDayOfCurrentMonth = currentMonth?.startDayOfCurrentMonth
        
        let months = startDayOfCurrentMonth
        
        Observable.just(months)
            .flatMap(fetchAMontlyCompletion(_:))
            .map { [[], $0, []] }
            .bind(to: completionOfMonths)
            .disposed(by: disposeBag)
    }
    
    func selectDate(_ date: Date) {
        selectedDate.onNext(date)
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
        
        return Observable.just(month)
            .concatMap { [weak self] date -> Observable<DailyQuestCompletion> in
                guard let self else { return Observable.empty() }
                
                return self.questsRepository
                    .fetch(by: self.user.uuid, date: date, filter: date)
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
