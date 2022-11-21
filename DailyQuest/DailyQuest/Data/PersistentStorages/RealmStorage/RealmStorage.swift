//
//  RealmStorage.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/14.
//

import RealmSwift
import Foundation

enum RealmStorageError: Error {
    case realmObjectError
    case noDataError
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

final class RealmStorage {
    static let shared = RealmStorage()

    private init() {
        // Realm file path
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }

    private let persistentContainer = try? Realm()

    @discardableResult
    func saveEntity<O: Object>(entity: O) throws -> O {
        guard let persistentContainer = persistentContainer else {
            throw RealmStorageError.realmObjectError
        }
        try persistentContainer.write {
            persistentContainer.add(entity)
        }
        return entity
    }

    func fetchEntities<O: Object>(type: O.Type, filter: String? = nil) throws -> [O] {
        guard let persistentContainer = persistentContainer else {
            throw RealmStorageError.realmObjectError
        }
        if let filter = filter {
            return Array(persistentContainer.objects(type).filter(filter))
        } else {
            return Array(persistentContainer.objects(type))
        }
    }

    @discardableResult
    func updateEntity<O: Object>(entity: O) throws -> O {
        guard let persistentContainer = persistentContainer else {
            throw RealmStorageError.realmObjectError
        }
        try persistentContainer.write {
            persistentContainer.add(entity, update: .modified)
        }
        return entity
    }

    @discardableResult
    func deleteEntity<O: Object>(entity: O) throws -> O {
        guard let persistentContainer = persistentContainer else {
            throw RealmStorageError.realmObjectError
        }
        try persistentContainer.write {
            persistentContainer.delete(entity)
        }

        return entity
    }

    func findEntities<O: Object>(type: O.Type, filter: String) throws -> [O] {
        guard let persistentContainer = persistentContainer else {
            throw RealmStorageError.realmObjectError
        }
        return Array(persistentContainer.objects(type).filter(filter))
    }

}
