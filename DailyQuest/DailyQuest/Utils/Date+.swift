//
//  Date+.swift
//  DailyQuest
//
//  Created by 이전희 on 2022/11/17.
//

import Foundation

extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    var toFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        return dateFormatter.string(from: self)
    }
}

extension Date {
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var nextMonthOfCurrentDay: Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }
    
    var lastMonthOfCurrentDay: Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    var startDayOfCurrentMonth: Date? {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)
    }
    
    var endDayOfCurrentMonth: Date? {
        guard let nextMonth = startDayOfNextMonth else { return nil }
        
        return Calendar.current.date(byAdding: .day, value: -1, to: nextMonth)
    }
    
    var startDayOfNextMonth: Date? {
        guard let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: self) else { return nil }
        
        return nextMonth.startDayOfCurrentMonth
    }
    
    var endDayOfNextMonth: Date? {
        guard let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: self) else { return nil }
        
        return nextMonth.endDayOfCurrentMonth
    }
    
    var startDayOfLastMonth: Date? {
        guard let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: self) else { return nil }
        
        return lastMonth.startDayOfCurrentMonth
    }
    
    var endDayOfLastMonth: Date? {
        guard let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: self) else { return nil }
        
        return lastMonth.endDayOfCurrentMonth
    }
    
    var rangeFromStartWeekdayOfLastMonthToEndDayOfCurrentMonth: [Date] {
        guard
            let endDayOfLastMonth = self.endDayOfLastMonth,
            let range = Calendar.current.range(of: .day, in: .weekOfMonth, for: endDayOfLastMonth),
            range.count < 7
        else {
            return []
        }
        
        return range.compactMap { day -> Date? in
            let components = DateComponents(month: endDayOfLastMonth.month, day: day)
            
            return Calendar.current.nextDate(
                after: self,
                matching: components,
                matchingPolicy: .nextTime,
                direction: .backward
            )
        }
    }
    
    var rangeDaysOfMonth: [Date] {
        guard
            let endDayOfLastMonth = self.endDayOfLastMonth,
            let range = Calendar.current.range(of: .day, in: .month, for: self)
        else {
            return []
        }
        
        return range.compactMap { day -> Date? in
            let components = DateComponents(year: self.year, month: self.month, day: day)
            
            return Calendar.current.nextDate(
                after: endDayOfLastMonth,
                matching: components,
                matchingPolicy: .nextTime
            )
        }
    }
}
