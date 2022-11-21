//
//  DefaultQuestsRepository.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/21.
//

import RxSwift

final class DefaultQuestsRepository {
    
    private let cache: UserQuestsStorage
    
    init(cache: UserQuestsStorage){
        self.cache = cache
    }
}

extension DefaultQuestsRepository: QuestsRepository {
    func save(with quest: [Quest]) -> RxSwift.Single<[Quest]> {
       
    }
    
    func fetch(by date: Date) -> RxSwift.Observable<[Quest]> {
       
    }
    
    func update(with quest: Quest) -> RxSwift.Single<Quest> {
        
    }
    
    func delete(with questId: UUID) -> RxSwift.Single<Quest> {
        
    }
    
    func deleteAll(with groupId: UUID) -> RxSwift.Single<[Quest]> {
        
    }
    
    
}
