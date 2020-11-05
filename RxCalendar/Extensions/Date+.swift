//
//  Date+.swift
//  RxCalendar
//
//  Created by Collabera on 11/5/20.
//

import Foundation

extension Date {
  func isTheSameDay(as date: Date) -> Bool {
    return Calendar.current.isDate(self, inSameDayAs: date)
  }
  
  func convertToLocalMidnight() -> Date {
    var currentCalendar = Calendar(identifier: .gregorian)
    currentCalendar.timeZone = .current
    return currentCalendar.startOfDay(for: self)
  }

  func dateIsInRange(_ range: (Date, Date)) -> Bool {
    return (self.compare(range.0) == .orderedDescending ||
      self.compare(range.0) == .orderedSame) && self.compare(range.1) == .orderedAscending
  }

  var endOfDay: Date {
    let startOfNextDay = Calendar.current.date(byAdding: .day, value: 1, to: self)!.convertToLocalMidnight()
    return Calendar.current.date(byAdding: .minute, value: -1, to: startOfNextDay)!
  }

  func dateByAdding(day amount: Int) -> Date {
    guard amount != 0 else { return self }
    let amountOfDays = amount
    return Calendar.current.date(byAdding: .day, value: amountOfDays, to: self)!
  }
}
