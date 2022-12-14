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
    case saveError(Error)
    case readError(Error)
    case updateError(Error)
    case deleteError(Error)
}

final class RealmStorage {
    static let shared = RealmStorage()
    private let persistentContainer = try? Realm()
    
    private init() {
        // Realm file path
        #if DEBUG
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        #endif
    }
}

extension RealmStorage {
    @discardableResult
    func createEntity<O: Object>(entity: O) throws -> O {
        guard let persistentContainer = persistentContainer else {
            throw RealmStorageError.realmObjectError
        }
        try persistentContainer.write {
            persistentContainer.add(entity, update: .modified)
        }
        return entity
    }
    
    func readEntities<O: Object>(type: O.Type, filter: NSPredicate? = nil) throws -> [O] {
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
    
    @discardableResult
    func deleteAllEntity<O: Object>(type: O.Type) throws -> [O] {
        guard let persistentContainer = persistentContainer else {
            throw RealmStorageError.realmObjectError
        }
        for entity in Array(persistentContainer.objects(type)) {
            try persistentContainer.write {
                persistentContainer.delete(entity)
            }
        }
        return Array(persistentContainer.objects(type))
    }
}
