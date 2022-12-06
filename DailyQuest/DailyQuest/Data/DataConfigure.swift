//
//  DataConfigure.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/12/05.
//

import Foundation

enum DateFilter {
    case today(_ date: Date)
    case month(_ date: Date)
    case year(_date: Date)
}
