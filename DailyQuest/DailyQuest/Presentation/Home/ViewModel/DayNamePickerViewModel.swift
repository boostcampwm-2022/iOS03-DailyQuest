//
//  DayNamePickerViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/30.
//

import Foundation

import RxSwift
import RxRelay

final class DayNamePickerViewModel {
    private var selectedDay = [1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false]
    private(set) var selectedDayObservable = BehaviorRelay<[Int: Bool]>(value: [1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false])
    private var disposableBag = DisposeBag()
    
    init() { /** usecase injection goes here if needed. */}

    struct Input {
        let buttonDidClicked: Observable<Int>
    }
    
    struct Output {
        let switchButtonStatus: Observable<(Int, Bool?)>
    }
    
    func transform(input: Input) -> Output {
        let switchButtonStatus = input
            .buttonDidClicked
            .map(didClicked(by:))
            .asObservable()
        
        return Output(switchButtonStatus: switchButtonStatus)
    }
    
    private func didClicked(by index: Int) -> (Int, Bool?) {
        selectedDay[index]?.toggle()
        selectedDayObservable.accept(selectedDay)
        
        return (index, selectedDay[index])
    }
}
