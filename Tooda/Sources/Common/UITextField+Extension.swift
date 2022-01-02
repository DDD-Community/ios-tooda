//
//  UITextField+Extension.swift
//  Tooda
//
//  Created by Lyine on 2021/05/23.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

extension UITextField {
  func placeholderColor(_ color: UIColor) {
    var placeholderText = ""
    if self.placeholder != nil {
      placeholderText = self.placeholder!
    }
    self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: color])
  }
}

private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
  
  var maxLength: Int {
    get {
      if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
        return length
      } else {
        return Int.max
      }
    }
    set {
      objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
      addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
    }
  }
  
  @objc func checkMaxLength(textField: UITextField) {
    guard let prospectiveText = self.text,
          prospectiveText.count > maxLength
    else {
      return
    }
    
    let selection = selectedTextRange
    
    let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
    let substring = prospectiveText[..<indexEndOfText]
    text = String(substring)
    
    selectedTextRange = selection
  }
}
