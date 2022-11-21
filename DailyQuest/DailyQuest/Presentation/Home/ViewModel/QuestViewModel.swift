//
//  QuestViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/16.
//

import Foundation

import RxSwift
import RxCocoa

final class QuestViewModel {
    private let questUseCase: QuestUseCase
        
    init(questUseCase: QuestUseCase) {
        self.questUseCase = questUseCase
    }
    
    struct Input {
        let viewDidLoad: Observable<Date>
    }
    
    struct Output {
        let data = PublishSubject<[Quest]>()
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input
            .viewDidLoad
            .flatMap(questUseCase.fetch(by:))
            .bind(to: output.data)
            .disposed(by: disposeBag)
        
        return output
    }
}
