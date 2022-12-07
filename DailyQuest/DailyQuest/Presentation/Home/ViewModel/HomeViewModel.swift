//
//  HomeViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/07.
//

import Foundation

import RxSwift
import RxCocoa

final class HomeViewModel {
    private let userUseCase: UserUseCase
    private let questUseCase: QuestUseCase
    private var calendarUseCase: CalendarUseCase

    init(userUseCase: UserUseCase, questUseCase: QuestUseCase, calendarUseCase: CalendarUseCase) {
        self.userUseCase = userUseCase
        self.questUseCase = questUseCase
        self.calendarUseCase = calendarUseCase
    }

    struct Input {
        let viewDidLoad: Observable<Date>
        let itemDidClicked: Observable<Quest>
        let profileButtonDidClicked: Observable<Void>
        let dragEventInCalendar: Observable<CalendarView.ScrollDirection>
        let daySelected: Observable<Date>
    }

    struct Output {
        let data: Driver<[Quest]>
        let userData: Observable<User>
        let profileTapResult: Observable<Bool>
        let currentMonth: Observable<Date?>
        let displayDays: Driver<[[DailyQuestCompletion]]>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {

        let updated = input
            .itemDidClicked
            .compactMap { $0.increaseCount() }
            .flatMap(questUseCase.update(with:))
            .filter({ $0 })
            .map { _ in Date() }
            .asObservable()

        let notification = NotificationCenter
            .default
            .rx
            .notification(.updated)
            .compactMap({ $0.object as? Date })
        
        let logged = userUseCase
            .isLoggedIn()
            .map { _ in Date() }

        let data = Observable
            .merge(updated,
                   input.viewDidLoad,
                   notification,
                   input.daySelected,
                   logged)
            .flatMap(questUseCase.fetch(by:))
            .asDriver(onErrorJustReturn: [])

        let userData = userUseCase
            .fetch()

        let profileTapResult = input
            .profileButtonDidClicked
            .flatMap { [weak self] _ in
            guard let self = self else { return Observable.just(false) }
            return self.userUseCase.isLoggedIn().take(1)
        }

        input
            .viewDidLoad
            .subscribe(onNext: { [weak self] _ in
            self?.calendarUseCase.setupMonths()
        })
            .disposed(by: disposeBag)

        input
            .dragEventInCalendar
            .subscribe(onNext: { [weak self] direction in
            switch direction {
            case .prev:
                self?.calendarUseCase.fetchLastMontlyCompletion()
            case .none:
                break
            case .next:
                self?.calendarUseCase.fetchNextMontlyCompletion()
            }
        })
            .disposed(by: disposeBag)

        let currentMonth = calendarUseCase
            .currentMonth
            .asObserver()

        let displayDays = calendarUseCase
            .completionOfMonths
            .asDriver(onErrorJustReturn: [[], [], []])

        return Output(data: data,
                      userData: userData,
                      profileTapResult: profileTapResult,
                      currentMonth: currentMonth,
                      displayDays: displayDays)
    }
}
