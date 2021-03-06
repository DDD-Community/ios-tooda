//
//  UIEdgeInsets+Extension.swift
//  Tooda
//
//  Created by jinsu on 2021/07/18.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

public protocol _UIEdgeInsetsProtocol {
  var top: CGFloat { get set }
  var left: CGFloat { get set }
  var bottom: CGFloat { get set }
  var right: CGFloat { get set }

  init()
}

public extension _UIEdgeInsetsProtocol {
  init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
    self.init()
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
  }

  init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
    self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
  }

  init(all: CGFloat) {
    self.init(top: all, left: all, bottom: all, right: all)
  }
}

extension UIEdgeInsets: _UIEdgeInsetsProtocol {}
