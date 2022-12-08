//
//  NetworkService.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/17.
//

import RxSwift
import RxRelay
import Foundation

enum NetworkServiceError: Error {
    case noNetworkService // NetworkService X
    case noAuthError // uid X
    case permissionDenied // wrong access
    case needFilterError
    case noUrlError
    case noDataError
}

protocol NetworkService {
    var uid: BehaviorRelay<String?> { get }

    func signIn(email: String, password: String) -> Single<Bool>
    func signOut() -> Single<Bool>
    func signUp(email: String, password: String, userDto: UserDTO) -> Single<Bool>
    func deleteUser() -> Single<Bool>

    func create<T: DTO>(userCase: UserCase, access: Access, dto: T) -> Single<T>
    func read<T: DTO>(type: T.Type, userCase: UserCase, access: Access, filter: DateFilter?) -> Observable<T>
    func update<T: DTO>(userCase: UserCase, access: Access, dto: T) -> Single<T>
    func delete<T: DTO>(userCase: UserCase, access: Access, dto: T) -> Single<T>

    func uploadDataStorage(data: Data, path: StoragePath) -> Single<String>
    func downloadDataStorage(fileName: String) -> Single<Data>
    func deleteDataStorage(forUrl: String) -> Single<Bool>

    func getAllowUsers(limit: Int) -> Observable<UserDTO>
}
