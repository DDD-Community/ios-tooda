//
//  UIView+Extension.swift
//  Tooda
//
//  Created by 황재욱 on 2021/06/15.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

extension UIView {
  func addSubviews(_ subviews: UIView...) {
    subviews.forEach(addSubview)
  }
}
