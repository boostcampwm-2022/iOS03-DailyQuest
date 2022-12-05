//
//  EnrollViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/30.
//

import Foundation

import RxSwift
import RxCocoa

final class EnrollViewModel {
    private var selectedDay = [1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false]
    private var selectedDayObservable = BehaviorRelay<[Int: Bool]>(value: [1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false])
    
    private var disposableBag = DisposeBag()
    
    init() {
        
    }
    
    struct Input {
        let titleDidChanged: Observable<String>
        let startDateDidSet: Observable<Date>
        let endDateDidSet: Observable<Date>
        let quantityDidSet: Observable<String>
        let submitButtonDidClicked: Observable<Void>
        
        let dayButtonDidClicked: Observable<Int>
    }
    
    struct Output {
        let buttonEnabled: Driver<Bool>
        let enrollResult: Observable<Bool>
        let dayButtonStatus: Observable<(Int, Bool?)>
    }
    
    func transform(input: Input) -> Output {
        Observable.combineLatest(
            input.startDateDidSet,
            input.endDateDidSet,
            self.selectedDayObservable
        )
            .compactMap(getDates(start:end:weekday:))
            .subscribe(onNext: { print($0) })
            .disposed(by: disposableBag)
        
        let buttonEnabled = Observable.combineLatest(
            input.titleDidChanged,
            input.quantityDidSet) { title, quantity in
                !title.isEmpty && !quantity.isEmpty
            }
            .asDriver(onErrorJustReturn: false)
        
        let dayButtonStatus = input
            .dayButtonDidClicked
            .map(didClicked(by:))
            .asObservable()
        
        return Output(buttonEnabled: buttonEnabled,
                      enrollResult: .just(true),
                      dayButtonStatus: dayButtonStatus)
    }
    
    
}

extension EnrollViewModel {
    private func getDates(start: Date, end: Date, weekday: [Int: Bool]) -> [Date]? {
        let weekdays = weekday
            .compactMap { (key: Int, value: Bool) in
                if value {
                    return key
                } else {
                    return nil
                }
            }
        
        var dates: [Date] = []
        var date = start
        
        while date <= end {
            guard let weekday = Calendar(identifier: .gregorian).dateComponents([.weekday], from: date).weekday else { return nil }
            if weekdays.contains(weekday) {
                dates.append(date)
            }
            
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        
        return dates
    }
    
    private func didClicked(by index: Int) -> (Int, Bool?) {
        selectedDay[index]?.toggle()
        selectedDayObservable.accept(selectedDay)
        
        return (index, selectedDay[index])
    }
}
