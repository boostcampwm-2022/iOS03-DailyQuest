//
//  FirebaseService.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/17.
//

import Firebase
import RxSwift
import RxRelay
import FirebaseCore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage

final class FirebaseService: NetworkService {
    static let shared = FirebaseService()
    private let auth: Auth
    private let db: Firestore
    private let storage: Storage

    private(set) var uid: BehaviorRelay<String?> = BehaviorRelay(value: nil)

    private init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
        auth = Auth.auth()
        storage = Storage.storage()
        uid.accept(auth.currentUser?.uid)
    }

    @discardableResult
    private func documentReference(userCase: UserCase) throws -> DocumentReference {
        switch userCase {
        case .currentUser:
            guard let currentUserUid = uid.value else { throw NetworkServiceError.noAuthError }
            return db.collection(userCase.path).document(currentUserUid)
        case let .anotherUser(uid):
            return db.collection(userCase.path).document(uid)
        }
    }

    private func checkPermission(crud: CRUD, userCase: UserCase, access: Access) throws {
        switch userCase {
        case .currentUser:
            switch access {
            case .receiveQuests:
                if crud == .create { throw NetworkServiceError.permissionDenied }
            default:
                break
            }
        case .anotherUser:
            switch access {
            case .receiveQuests:
                if crud == .delete { throw NetworkServiceError.permissionDenied }
            default:
                if crud != .read { throw NetworkServiceError.permissionDenied }
            }
        }
    }

    func signIn(email: String, password: String) -> Single<Bool> {
        return Single.create { [weak self] single in
            do {
                guard let self = self else { throw NetworkServiceError.noNetworkService }
                self.auth.signIn(withEmail: email, password: password) { (authResult, error) in
                    if let error = error {
                        single(.failure(error))
                    }
                    
                    self.uid.accept(self.auth.currentUser?.uid)
                    single(.success(true))
                }
            } catch let error {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }

    func signOut() -> Single<Bool> {
        return Single.create { [weak self] single in
            do {
                guard let self = self else { throw NetworkServiceError.noNetworkService }
                try self.auth.signOut()
                
                self.uid.accept(self.auth.currentUser?.uid)
                single(.success(true))
            } catch let error {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }

    /// Create
    /// - Parameters:
    ///   - userCase: current User / another User
    ///   - access: quests / receiveQuests / userInfo
    ///   - dto: DTO (Codable)
    /// - Returns: Single<T>
    func create<T: DTO>(userCase: UserCase, access: Access, dto: T) -> Single<T> {
        return Single<T>.create { [weak self] single in
            do {
                guard let self = self else { throw NetworkServiceError.noNetworkService }
                try self.checkPermission(crud: .create, userCase: userCase, access: access)
                guard let uid = self.uid.value else { throw NetworkServiceError.noAuthError }
                let ref = try self.documentReference(userCase: userCase)
                switch access {
                case .quests:
                    try ref.collection(access.path)
                        .document("\(dto.uuid)")
                        .setData(from: dto)
                case .receiveQuests:
                    try ref.collection(access.path)
                        .document(uid)
                        .setData(from: dto)
                case .userInfo:
                    try ref
                        .setData(from: dto)
                }
                single(.success(dto))
            } catch let error {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }

    /// Read
    /// - Parameters:
    ///   - type: return Type
    ///   - userCase: current User / another User
    ///   - access: quests / receiveQuests / userInfo
    ///   - condition: quests - today(date) / month(date) / year(date)
    /// - Returns: Observable<T>
    func read<T: DTO>(type: T.Type, userCase: UserCase, access: Access, filter: NetworkDateFilter? = nil) -> Observable<T> {
        return Observable<T>.create { [weak self] observer in
            do {
                guard let self = self else { throw NetworkServiceError.noNetworkService }
                try self.checkPermission(crud: .read, userCase: userCase, access: access)
                let ref = try self.documentReference(userCase: userCase)
                switch access {
                case .quests:
                    guard let filter = filter else { throw NetworkServiceError.needConditionError }
                    var query: Query? = nil
                    switch filter {
                    case let .today(date):
                        query = ref.collection(access.path)
                            .whereField("date", isEqualTo: date.toString)
                    case let .month(date):
                        let month = date.toString.components(separatedBy: "-")[0...1].joined(separator: "-")
                        query = ref.collection(access.path)
                            .whereField("date", isGreaterThan: "\(month)-00")
                            .whereField("date", isLessThan: "\(month)-40")
                    case let .year(date):
                        let year = date.toString.components(separatedBy: "-")[0]
                        query = ref.collection(access.path)
                            .whereField("date", isGreaterThan: "\(year)-01-00")
                            .whereField("date", isLessThan: "\(year)-12-40")
                    }
                    query?.getDocuments { (querySnapshot, err) in
                        for document in querySnapshot!.documents {
                            do {
                                let quest = try document.data(as: type)
                                observer.onNext(quest)
                            } catch let error {
                                observer.onError(error)
                            }
                        }
                        observer.onCompleted()
                    }
                case .receiveQuests:
                    ref.collection(access.path).getDocuments { (querySnapshot, error) in
                        for document in querySnapshot!.documents {
                            do {
                                let quest = try document.data(as: type)
                                observer.onNext(quest)
                            } catch let error {
                                observer.onError(error)
                            }
                        }
                        observer.onCompleted()
                    }
                case .userInfo:
                    ref.getDocument(as: type) { result in
                        switch result {
                        case .success(let userInfo):
                            observer.onNext(userInfo)
                        case .failure(let error):
                            observer.onError(error)
                        }
                        observer.onCompleted()
                    }
                }
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    /// Update
    /// - Parameters:
    ///   - userCase: current User / another User
    ///   - access: quests / receiveQuests / userInfo
    ///   - dto: DTO (Codable)
    /// - Returns: Single<T>
    func update<T: DTO>(userCase: UserCase, access: Access, dto: T) -> Single<T> {
        return Single<T>.create { [weak self] single in
            do {
                guard let self = self else { throw NetworkServiceError.noNetworkService }
                try self.checkPermission(crud: .update, userCase: userCase, access: access)
                guard let uid = self.uid.value else { throw NetworkServiceError.noAuthError }
                let ref = try self.documentReference(userCase: userCase)
                switch access {
                case .quests:
                    try ref.collection(access.path)
                        .document("\(dto.uuid)")
                        .setData(from: dto, merge: true)
                case .receiveQuests:
                    try ref.collection(access.path)
                        .document(uid)
                        .setData(from: dto, merge: true)
                case .userInfo:
                    try ref
                        .setData(from: dto, merge: true)
                }
                single(.success(dto))
            } catch let error {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }

    /// Delete
    /// - Parameters:
    ///   - userCase: current User / another User
    ///   - access: quests / receiveQuests / userInfo
    ///   - dto: DTO (Codable)
    /// - Returns: Single<T>
    func delete<T: DTO>(userCase: UserCase, access: Access, dto: T) -> Single<T> {
        return Single<T>.create { [weak self] single in
            do {
                guard let self = self else { throw NetworkServiceError.noNetworkService }
                try self.checkPermission(crud: .delete, userCase: userCase, access: access)
                guard let uid = self.uid.value else { throw NetworkServiceError.noAuthError }
                let ref = try self.documentReference(userCase: userCase)
                switch access {
                case .quests:
                    ref.collection(access.path).document("\(dto.uuid)").delete() { error in
                        if let error = error {
                            single(.failure(error))
                        } else {
                            single(.success(dto))
                        }
                    }
                case .receiveQuests:
                    ref.collection(access.path).document(uid).delete() { error in
                        if let error = error {
                            single(.failure(error))
                        } else {
                            single(.success(dto))
                        }
                    }
                case .userInfo:
                    ref.delete() { error in
                        if let error = error {
                            single(.failure(error))
                        } else {
                            single(.success(dto))
                        }
                    }
                }
            } catch let error {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }

    /// uploadDataStorage
    /// - Parameters:
    ///   - data: Image Data
    ///   - path: profileImages / backgroundImages / another(_ path: String)
    /// - Returns: success -> File Name, failure -> error
    func uploadDataStorage(data: Data, path: StoragePath) -> Single<String> {
        return Single<String>.create { [weak self] single in
            do {
                guard let self = self else { throw NetworkServiceError.noNetworkService }
                guard let uid = self.uid.value else { throw NetworkServiceError.noAuthError }
                let fileName = "\(path.path)/\(uid)-\(UUID())"
                let StorageReference = self.storage.reference().child("\(fileName)")

                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"

                StorageReference.putData(data, metadata: metaData) { metaData, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    StorageReference.downloadURL { (url, error) in
                        guard let _ = url else {
                            single(.failure(NetworkServiceError.noUrlError))
                            return
                        }
                        single(.success(fileName))
                    }
                }
            } catch let error {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    /// downloadDataStorage
    /// - Parameter fileName: File Name
    /// - Returns: success -> Image Data, failure -> error
    func downloadDataStorage(fileName: String) -> Single<Data> {
        return Single<Data>.create { [weak self] single in
            do {
                guard let self = self else { throw NetworkServiceError.noNetworkService }

                let storageReference = self.storage.reference().child(fileName)
                let megaByte = Int64(1 * 1024 * 1024)

                storageReference.getData(maxSize: megaByte) { data, error in
                    guard let imageData = data else {
                        single(.failure(NetworkServiceError.noDataError))
                        return
                    }
                    single(.success(imageData))
                }
            } catch let error {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    /// deleteDataStorage
    /// - Parameter fileName: File Name
    /// - Returns: success -> true, Data, failure -> error
    func deleteDataStorage(fileName: String) -> Single<Bool> {
        return Single<Bool>.create { [weak self] single in
            do {
                guard let self = self else { throw NetworkServiceError.noNetworkService }

                let storageReference = self.storage.reference().child(fileName)

                storageReference.delete { error in
                    if let error = error {
                        single(.failure(error))
                    } else {
                        single(.success(true))
                    }
                }
            } catch let error {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

}
