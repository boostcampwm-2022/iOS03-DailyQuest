//
//  FirebaseService.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/17.
//

import RxSwift
import Firebase
import FirebaseAuth
import FirebaseFirestore

final class FirebaseService: NetworkService {
    static let shared = FirebaseService()
    private let auth: Auth
    private let db: Firestore

    private(set) var uid: String?

    private init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
        auth = Auth.auth()
        uid = auth.currentUser?.uid
    }

    private func documnetReference(userCase: UserCase, access: Access) -> DocumentReference? {
        switch userCase {
        case .currentUser:
            guard let currentUserUid = uid else { return nil }
            return db.collection("users").document(currentUserUid)
        case let .anotherUser(uid):
            return db.collection("users").document(uid)
        }
    }

    func create<T: Codable>(userCase: UserCase, access: Access) -> Single<T> {
        return Single<T>.create { single in


            return Disposables.create()
        }
    }

    func read<T: Codable>(userCase: UserCase, access: Access) -> Observable<T> {
        return Observable<T>.create { observer in


            return Disposables.create()
        }
    }

    func update<T: Codable>(userCase: UserCase, access: Access) -> Single<T> {
        return Single<T>.create { single in

            return Disposables.create()
        }
    }

    func delete<T: Codable>(userCase: UserCase, access: Access) -> Single<T> {
        return Single<T>.create { single in

            return Disposables.create()
        }
    }

}

