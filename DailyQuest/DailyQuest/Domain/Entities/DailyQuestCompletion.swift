//
//  DailyQuestCompletion.swift
//  DailyQuest
//
//  Created by wickedRun on 2022/12/06.
//

import Foundation

struct DailyQuestCompletion {
    
    enum State {
        case hidden
        case normal
        case notDone(Int)
        case done
    }
    
    let day: Date
    let state: State
}
