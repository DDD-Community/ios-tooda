//
//  NSAttributedString+Extension.swift
//  Tooda
//
//  Created by jinsu on 2021/07/18.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

extension NSAttributedString {
  typealias Style = [NSAttributedString.Key: Any]

  static func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
  }
}
