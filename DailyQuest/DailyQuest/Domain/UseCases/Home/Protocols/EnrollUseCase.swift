//
//  EnrollUseCase.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/05.
//

import Foundation

import RxSwift

protocol EnrollUseCase {
    func save(with quests: [Quest]) -> Observable<Bool>
}
