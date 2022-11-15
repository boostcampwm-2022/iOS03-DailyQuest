//
//  RealmStorage.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/14.
//

import Realm
import RealmSwift
import Foundation

enum RealmStorageError: Error {
    case realmObjectError
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

final class RealmStorage {
    static let shared = RealmStorage()
    private init() { }

    private let persistentContainer = try? Realm()

    func updateEntity(entity: Object) throws {
        guard let persistentContainer = persistentContainer else {
            throw RealmStorageError.realmObjectError
        }
        try persistentContainer.write {
            persistentContainer.add(entity)
        }
    }

    func fetchEntities<O: Object>(type: O.Type) throws -> [O] {
        guard let persistentContainer = persistentContainer else {
            throw RealmStorageError.realmObjectError
        }
        return Array(persistentContainer.objects(type))
    }
}
