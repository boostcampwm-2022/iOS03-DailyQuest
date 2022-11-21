//
//  FirebaseService.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/17.
//

import RxSwift
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

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

    private func documnetReference(userCase: UserCase) -> DocumentReference? {
        switch userCase {
        case .currentUser:
            guard let currentUserUid = uid else { return nil }
            return db.collection("users").document(currentUserUid)
        case let .anotherUser(uid):
            return db.collection("users").document(uid)
        }
    }

    func create<T: Codable>(userCase: UserCase, access: Access, dto: T) -> Single<T> {
        self.db.collection("users").document("user1").collection("quests")
            .whereField("date", isEqualTo: Date().toString)
            .getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        
        let data = QuestDTO(uuid: UUID(), title: "이다연 여기 묻히다", currentCount: 0, totalCount: 0, groupUid: UUID())
        
        do {
        try self.db.collection("users").document("user1").collection("quests")
            .document("\(data.uuid)")
            .setData(from: data)
        } catch let error {
            print(error)
        }
        
        return Single<T>.create { single in
            switch access {
            case .quests:
                break
            case .receiveQuests:
                break
            case .userInfo:
                break
            }
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

