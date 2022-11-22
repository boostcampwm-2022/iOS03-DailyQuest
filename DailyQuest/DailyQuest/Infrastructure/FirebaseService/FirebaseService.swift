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
        print(uid)
    }
    
    private func documentReference(userCase: UserCase) -> DocumentReference? {
        switch userCase {
        case .currentUser:
            // guard let currentUserUid = uid else { return nil }
            return db.collection("users").document("user1") // user 변경해야해요
        case let .anotherUser(uid):
            return db.collection("users").document(uid)
        }
    }
    
    func create<T: DTO>(userCase: UserCase, access: Access, dto: T) -> Single<T> {
        return Single<T>.create { single in
            guard let uid = self.uid, let ref = self.documentReference(userCase: userCase) else {
                // single(.failure()) // Firebase Error 추가
                return Disposables.create()
            }
            
            switch access {
            case .quests:
                do {
                    try ref.collection("quests")
                        .document("\(dto.uuid)")
                        .setData(from: dto)
                    single(.success(dto))
                } catch let error {
                    single(.failure(error))
                }
            case .receiveQuests:
                do {
                    try ref.collection("receiveQuests")
                        .document(uid)
                        .setData(from: dto)
                    single(.success(dto))
                } catch let error {
                    single(.failure(error))
                }
            case .userInfo:
                do {
                    try ref
                        .setData(from: dto)
                    single(.success(dto))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func read<T: DTO>(type: T.Type, userCase: UserCase, access: Access, condition: NetworkCondition? = nil) -> Observable<T> {
        
        return Observable<T>.create { observer in
            guard let ref = self.documentReference(userCase: userCase) else {
                // single(.failure()) // Firebase Error 추가
                return Disposables.create()
            }
            
            switch access {
            case .quests:
                print("aaaa")
                let ref = ref.collection("quests")
                switch condition {
                case .none:
                    break
                case let .today(date):
                    ref.whereField("date", isEqualTo: date.toString)
                        .getDocuments { (querySnapshot, err) in
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                do {
                                    let quest = try document.data(as: type)
                                    observer.onNext(quest)
                                } catch let error {
                                    print(error)
                                }
                            }
                        }
                case .some(.month(_)):
                    break
                case .some(.year(_date: let _date)):
                    break
                }
            case .receiveQuests:
                break
            case .userInfo:
                break
            }
            
            
            return Disposables.create()
        }
    }
    
    func update<T: DTO>(userCase: UserCase, access: Access, dto: T) -> Single<T> {
        return Single<T>.create { single in
            guard let uid = self.uid, let ref = self.documentReference(userCase: userCase) else {
                // single(.failure()) // Firebase Error 추가
                return Disposables.create()
            }
            
            switch access {
            case .quests:
                do {
                    try ref.collection("quests")
                        .document("\(dto.uuid)")
                        .setData(from: dto, merge: true)
                    print(dto.uuid)
                    single(.success(dto))
                } catch let error {
                    single(.failure(error))
                }
            case .receiveQuests:
                do {
                    try ref.collection("receiveQuests")
                        .document(uid)
                        .setData(from: dto, merge: true)
                    single(.success(dto))
                } catch let error {
                    single(.failure(error))
                }
            case .userInfo:
                do {
                    try ref
                        .setData(from: dto, merge: true)
                    single(.success(dto))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func delete<T: DTO>(userCase: UserCase, access: Access, dto: T) -> Single<T> {
        return Single<T>.create { single in
            guard let uid = self.uid, let ref = self.documentReference(userCase: userCase) else {
                // single(.failure()) // Firebase Error 추가
                return Disposables.create()
            }
            
            switch access {
            case .quests:
                ref.collection("quests").document("\(dto.uuid)").delete() { error in
                    if let error = error {
                        single(.failure(error))
                    } else {
                        single(.success(dto))
                    }
                }
                print(dto.uuid)
            case .receiveQuests:
                ref.collection("receiveQuests").document(uid).delete() { error in
                    if let error = error {
                        single(.failure(error))
                    } else {
                        single(.success(dto))
                    }
                }
            case .userInfo:
                ref.delete()  { error in
                    if let error = error {
                        single(.failure(error))
                    } else {
                        single(.success(dto))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
}

