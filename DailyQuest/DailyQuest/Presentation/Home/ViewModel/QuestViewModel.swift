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
        let itemDidClicked: Observable<Quest>
    }
    
    struct Output {
        let data: Driver<[Quest]>
    }
    
    func transform(input: Input) -> Output {
        
        let updated = input
            .itemDidClicked
            .compactMap { $0.increaseCount() }
            .flatMap(questUseCase.update(with:))
            .filter({ $0 })
            .map { _ in Date() }
            .asObservable()
        
        let data = Observable
            .merge(updated, input.viewDidLoad)
            .flatMap(questUseCase.fetch(by:))
            .asDriver(onErrorJustReturn: [])
            
        return Output(data: data)
    }
}
