//
//  FriendQuestUseCase.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/08.
//

import Foundation

import RxSwift

protocol FriendQuestUseCase {
    func fetch(with uuid: String, by date: Date) -> Observable<[Quest]>
}
