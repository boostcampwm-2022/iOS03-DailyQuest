//
//  QuestsRepository.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/11/21.
//

import Foundation

import RxSwift

protocol QuestsRepository {
    /**
     해당 퀘스트를 저장합니다.
     
     - Parameters:
        - quest: 저장할 퀘스트입니다.
     - Returns: 성공시 Quest를, 실패시, error를 방출하는 Observable입니다.
     */
    func save(with quest: [Quest]) -> Single<[Quest]>

    /**
     해당 날짜의 퀘스트 배열을 받아옵니다.
     
     - Parameters:
        - date: 받아오길 원하는 날짜입니다.
     - Returns: Quest의 배열을 방출하는 Observable입니다. 비어있다면 비어있는 배열을 방출합니다.
     */
    func fetch(by date: Date) -> Single<[Quest]>

    /**
     해당 날짜의 퀘스트 값(`currentCount`)을 업데이트 합니다.
     
     - Parameters:
        - quest: 업데이트될 퀘스트입니다.
     - Returns: 성공시 Quest를, 실패시 error를 방출하는 Observable입니다.
     */
    func update(with quest: Quest) -> Single<Quest>

    /**
     해당 날짜에 해당하는 퀘스트의 값을 업데이트 합니다.
     
     - Parameters:
        - questId: 삭제하고자 하는 퀘스트의 id입니다.
     - Returns: 성공시 해당 Quest를, 실패시 error를 방출하는 Observable입니다.
     */
    func delete(with questId: UUID) -> Single<Quest>

    /**
     해당 group의 Quest를 모두 삭제합니다.
     
     
     - Parameters:
        - groupId: 삭제하고자 하는 퀘스트 그룹의 id입니다.
     - Returns: 성공시 해당 Quest 배열을, 실패시 error를 방출하는 Observable입니다.
     */
    func deleteAll(with groupId: UUID) -> Single<[Quest]>

    func fetch(by uuid: String, date: Date) -> Single<[Quest]>
    
    func fetch(by uuid: String, date: Date, filter: Date) -> Single<[Date: [Quest]]>
}
