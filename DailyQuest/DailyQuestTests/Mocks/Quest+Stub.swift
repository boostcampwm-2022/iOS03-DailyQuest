//
//  Quest+Stub.swift
//  DailyQuestTests
//
//  Created by jinwoong Kim on 2022/11/21.
//

import Foundation

extension Quest {
    static func stub(groupId: UUID,
                     uuid: UUID,
                     date: Date,
                     title: String,
                     currentCount: Int,
                     totalCount: Int) -> Self {
        return .init(groupId: groupId,
                     uuid: uuid,
                     date: date,
                     title: title,
                     currentCount: currentCount,
                     totalCount: totalCount)
    }
}
