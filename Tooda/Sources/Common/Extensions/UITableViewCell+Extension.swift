//
//  UITableViewCell+Extension.swift
//  Tooda
//
//  Created by lyine on 2021/05/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

// MARK: UITableViewCell
extension UITableViewCell {
  static var reuseIdentifierName: String {
    return String(describing: self)
  }
}
