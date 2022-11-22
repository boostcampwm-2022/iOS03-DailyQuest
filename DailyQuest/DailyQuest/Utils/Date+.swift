//
//  Date+.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/21.
//

import Foundation

 extension Date {
     var toString: String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         return dateFormatter.string(from: self)
     }
 }
