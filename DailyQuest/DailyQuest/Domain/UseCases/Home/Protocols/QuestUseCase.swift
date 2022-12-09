//
//  QuestUseCase.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/21.
//

import Foundation

import RxSwift

protocol QuestUseCase {
    func fetch(by date: Date) -> Single<[Quest]>
    func update(with quest: Quest) -> Single<Bool>
}
