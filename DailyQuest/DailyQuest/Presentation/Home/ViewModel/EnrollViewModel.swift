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
    
    private var disposableBag = DisposeBag()
    let dayNamePickerViewModel: DayNamePickerViewModel
    
    init(dayNamePickerViewModel: DayNamePickerViewModel) {
        self.dayNamePickerViewModel = dayNamePickerViewModel
    }
    
    struct Input {
        let titleDidChanged: Observable<String>
        let startDateDidSet: Observable<Date>
        let endDateDidSet: Observable<Date>
        let quantityDidSet: Observable<String>
        let submitButtonDidClicked: Observable<Void>
    }
    
    struct Output {
        let buttonEnabled: Driver<Bool>
        let enrollResult: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let dates = Observable.combineLatest(
            input.startDateDidSet,
            input.endDateDidSet,
            dayNamePickerViewModel.selectedDayObservable
        )
            .compactMap(getDates(start:end:weekday:))
        
        let buttonEnabled = Observable.combineLatest(
            input.titleDidChanged,
            input.quantityDidSet) { title, quantity in
                !title.isEmpty && !quantity.isEmpty
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(buttonEnabled: buttonEnabled, enrollResult: .just(true))
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
}
