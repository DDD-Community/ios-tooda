//
//  String+Extension.swift
//  Tooda
//
//  Created by 황재욱 on 2022/01/23.
//

import Foundation

extension String {
  
  func convertToDate() -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Date.DateFormatType.base.rawValue
    return dateFormatter.date(from: self)
  }
}
