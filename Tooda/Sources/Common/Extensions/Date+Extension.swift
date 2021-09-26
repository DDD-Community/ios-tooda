//
//  Date+String.swift
//  Tooda
//
//  Created by Jinsu Park on 2021/07/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

extension Date {

  init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    dateComponents.hour = hour
    dateComponents.minute = minute
    dateComponents.second = second

    guard let date = Calendar.current.date(from: dateComponents) else {
      self = Date()
      return
    }
    self = date
  }

  init(year: Int, month: Int, day: Int) {
    self.init(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
  }

  enum DateFormatType: String {
    case base = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    case ko = "yyyy년 MM월 dd일"
    case dot = "yyyy.MM.dd"
    case dotMonth = "yyyy.MM"
    case slash = "yyyy/MM/dd"
    case hyphen = "yyyy-MM-dd"
  }

  func string(_ type: DateFormatType = .base) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = type.rawValue
    dateFormatter.locale = Locale.current
    dateFormatter.timeZone = TimeZone.current
    return dateFormatter.string(from: self)
  }

  func component(_ component: Calendar.Component) -> Int {
    let calendar = Calendar.autoupdatingCurrent
    return calendar.component(component, from: self)
  }

  var year: Int {
    return self.component(.year)
  }

  var month: Int {
    return self.component(.month)
  }

  var week: Int {
    return self.component(.weekday)
  }

  var day: Int {
    return self.component(.day)
  }

  var hour: Int {
    return self.component(.hour)
  }

  var minute: Int {
    return self.component(.minute)
  }

  var second: Int {
    return self.component(.second)
  }

  var weekday: Int {
    return self.component(.weekday)
  }

  var weekdayOrdinal: Int {
    return self.component(.weekdayOrdinal)
  }

  var quarter: Int {
    return self.component(.quarter)
  }

  var weekOfMonth: Int {
    return self.component(.weekOfMonth)
  }

  var weekOfYear: Int {
    return self.component(.weekOfYear)
  }

  var yearForWeekOfYear: Int {
    return self.component(.yearForWeekOfYear)
  }
}
