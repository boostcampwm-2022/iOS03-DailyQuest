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
    private var selectedDay = [0: false, 1: false, 2: false, 3: false, 4: false, 5: false, 6: false]
    private(set) var selectedDayObservable = BehaviorRelay<[Int: Bool]>(value: [0: false, 1: false, 2: false, 3: false, 4: false, 5: false, 6: false])
    private var disposableBag = DisposeBag()
    
    init() { /** usecase injection goes here if needed. */}

    struct Input {
        let buttonDidClicked: Observable<Int>
    }
    
    struct Output {
        let switchButtonStatus: Observable<(Int, Bool?)>
    }
    
    func transform(input: Input) -> Output {
        print("transform start")
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
