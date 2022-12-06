//
//  ProtectedUserRepository.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/12/05.
//

import RxSwift

protocol ProtectedUserRepository {
    /// 유저정보를 삭제합니다.
    /// - Returns: 삭제 성공 여부를 방출하는 Observable입니다.
    func deleteUser() -> Observable<Bool>
}
