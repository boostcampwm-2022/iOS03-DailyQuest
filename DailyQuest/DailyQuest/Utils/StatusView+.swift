//
//  StatusView+.swift
//  DailyQuest
//
//  Created by jinwoong Kim on 2022/12/08.
//

import Foundation

extension StatusView {
    private var messages: [String] {
        ["화이팅", "잘 할 수 있어", "오늘은 공부를 해보자!", "Hello, World!", "🎹🎵🎶🎵🎶"]
    }
    
    func getRandomMessage() -> String {
        return messages.randomElement() ?? "Hello,World!"
    }
}
