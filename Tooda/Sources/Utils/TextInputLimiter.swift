//
//  TextInputLimiter.swift
//  Tooda
//
//  Created by Lyine on 2022/01/02.
//

import Foundation

// MARK: - TextInputLimitable

protocol TextInputLimitable {
  var maxLength: Int { get set }
  func shouldTextInMaxLength(propertyValue: String?, range: NSRange, replace: String) -> Bool
}

extension TextInputLimitable {
  func shouldTextInMaxLength(propertyValue: String?, range: NSRange, replace: String) -> Bool {
    
    guard let inputText = propertyValue,
          let range = Range(range, in: inputText) else {
            return false
          }
    
    let inputTextValueSubString = inputText[range]
    let count = inputText.count - inputTextValueSubString.count + replace.count
    
    return count <= maxLength
  }
}

struct TextInputLimiter: TextInputLimitable {
  var maxLength: Int
}
