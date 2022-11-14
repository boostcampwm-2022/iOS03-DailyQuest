//
//  RealmStorage.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/14.
//

import RealmSwift

enum RealmStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

final class RealmStorage {
    static let shared = RealmStorage()
    private init() {}
    
    private let persistentContainer = try? Realm()
}
