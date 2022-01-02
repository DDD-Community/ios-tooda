//
//  UITextView+Extension.swift
//  Tooda
//
//  Created by Lyine on 2022/01/02.
//

import UIKit

private var kAssociationKeyMaxLength: Int = 0

extension UITextView {
  
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
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(checkMaxLength(textView:)),
        name: UITextView.textDidChangeNotification,
        object: nil
      )
    }
  }
  
  @objc func checkMaxLength(textView: UITextView) {
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
