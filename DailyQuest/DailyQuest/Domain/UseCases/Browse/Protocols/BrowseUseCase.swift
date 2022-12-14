//
//  BrowseUseCase.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/29.
//

import Foundation

import RxSwift

protocol BrowseUseCase {
    func excute() -> Single<[BrowseQuest]>
}
