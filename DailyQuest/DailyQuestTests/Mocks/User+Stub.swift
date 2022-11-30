//
//  User+Stub.swift
//  DailyQuestTests
//
//  Created by jinwoong Kim on 2022/11/29.
//

import Foundation

extension User {
    static func stub(uuid: String = "",
                     nickName: String,
                     profileURL: String = "",
                     backgroundImageURL: String = "",
                     description: String = "",
                     allow: Bool = true) -> Self {
        return .init(uuid: uuid,
                     nickName: nickName,
                     profileURL: profileURL,
                     backgroundImageURL: backgroundImageURL,
                     description: description,
                     allow: allow)
    }
}
