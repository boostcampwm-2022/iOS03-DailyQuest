//
//  NetworkService.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/17.
//

import RxSwift

enum NetworkServiceError: Error {
    case noNetworkService
    case noAuthError
    case wrongAccessError
    case needConditionError
}

protocol NetworkService {
    var uid: String? { get }

    func create<T: DTO>(userCase: UserCase, access: Access, dto: T) -> Single<T>
    func read<T: DTO>(type: T.Type, userCase: UserCase, access: Access, condition: NetworkCondition?) -> Observable<T>
    func update<T: DTO>(userCase: UserCase, access: Access, dto: T) -> Single<T>
    func delete<T: DTO>(userCase: UserCase, access: Access, dto: T) -> Single<T>
}
