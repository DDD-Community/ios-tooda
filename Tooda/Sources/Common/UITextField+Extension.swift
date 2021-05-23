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
