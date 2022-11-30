//
//  EnrollViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/30.
//

import Foundation

import RxSwift

final class EnrollViewModel {
    let dayNamePickerViewModel: DayNamePickerViewModel
    
    init(dayNamePickerViewModel: DayNamePickerViewModel) {
        self.dayNamePickerViewModel = dayNamePickerViewModel
    }
    
    struct Input {
        let titleDidChanged: Observable<String>
        let startDateDidSet: Observable<Date>
        let endDateDidSet: Observable<Date>
        let quantityDidSet: Observable<Int>
        
        /** doneButtonDidClickedEvnet */
    }
    
    struct Output {
        let enrollResult: Observable<Bool>
    }
    
    func transform(input: Input) {}
}
