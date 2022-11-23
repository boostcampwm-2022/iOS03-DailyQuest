//
//  DTO.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/21.
//

import Foundation

protocol DTO: Codable {
    var uuid: UUID { get }
}
