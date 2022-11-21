//
//  NetworkService.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/17.
//

import RxSwift

enum NetworkServiceError {
    case noAuth
}

protocol NetworkService {
    var uid: String? { get }

    func create<T: Codable>(userCase: UserCase, access: Access, dto: T) -> Single<T>
    func read<T: Codable>(userCase: UserCase, access: Access) -> Observable<T>
    func update<T: Codable>(userCase: UserCase, access: Access) -> Single<T>
    func delete<T: Codable>(userCase: UserCase, access: Access) -> Single<T>
}
