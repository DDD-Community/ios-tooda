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

  func replace(key: String, value: String, style: Style) -> NSAttributedString {
    guard let mutableAttr = self.mutableCopy() as? NSMutableAttributedString else { return self }
    let target = "{" + key + "}"
    guard let range = self.string.range(of: target) else { return self }

    mutableAttr.replaceCharacters(
      in: NSRange(range, in: self.string),
      with: value.styled(with: style)
    )

    return mutableAttr
  }

  func replace(key: String, value: String) -> NSAttributedString {
    guard let mutableAttr = self.mutableCopy() as? NSMutableAttributedString else { return self }
    let target = "{" + key + "}"
    guard let range = self.string.range(of: target) else { return self }

    mutableAttr.replaceCharacters(
      in: NSRange(range, in: self.string),
      with: value
    )

    return mutableAttr
  }

  func replace(value: String, style: Style) -> NSAttributedString {
    guard let mutableAttr = self.mutableCopy() as? NSMutableAttributedString else { return self }
    guard let range = self.string.range(of: value) else { return self }

    mutableAttr.replaceCharacters(
      in: NSRange(range, in: self.string),
      with: value.styled(with: style)
    )

    return mutableAttr
  }

  class func composed(of strings: [NSAttributedString], separator: NSAttributedString) -> NSAttributedString {
    return strings.reduce(strings[0], { (s1, s2) -> NSAttributedString in
      let result = NSMutableAttributedString()
      result.append(s1)
      result.append(separator)
      result.append(s2)

      return result
    })
  }
}
