//
//  RepositoryManager.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/12/05.
//

import RxSwift

final class RepositoryManager {
    static let shared = RepositoryManager()
    private init() { }

    var disposeBag: DisposeBag = DisposeBag()
}
