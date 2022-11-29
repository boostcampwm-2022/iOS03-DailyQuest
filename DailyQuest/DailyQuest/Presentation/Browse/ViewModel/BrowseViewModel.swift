//
//  BrowseViewModel.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/15.
//

import Foundation

import RxSwift
import RxCocoa

final class BrowseViewModel {
    private let browseUseCase: BrowseUseCase
    private(set) var cellCount: [Int] = []
    
    init(browseUseCase: BrowseUseCase) {
        self.browseUseCase = browseUseCase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let data: Driver<[BrowseItemViewModel]>
    }
    
    func transform(input: Input) -> Output {
        let data = input
            .viewDidLoad
            .flatMap { _ in
                self.browseUseCase.excute()
            }
            .map(transform(with:))
            .do(onNext: { [weak self] items in
                items.forEach { item in
                    self?.cellCount.append(item.quests.count)
                }
            })
            .asDriver(onErrorJustReturn: [])
        
        return Output(data: data)
    }
    
    private func transform(with browseQuests: [BrowseQuest]) -> [BrowseItemViewModel] {
        return browseQuests.map { browseQuest in
            BrowseItemViewModel(user: browseQuest.user, quests: browseQuest.quests)
        }
    }
}
