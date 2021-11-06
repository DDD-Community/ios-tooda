//
//  UIBarButtonItem+Extension.swift
//  Tooda
//
//  Created by Jinsu Park on 2021/11/06.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
  
  private struct AssociatedKeys {
    static var targetClosure = "targetClosure"
  }
  
  private var _action: (() -> Void)? {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? () -> Void
    }
    set {
      objc_setAssociatedObject(
        self,
        &AssociatedKeys.targetClosure,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
  
  convenience init(image: UIImage?, style: UIBarButtonItem.Style, action: @escaping () -> Void) {
    self.init(image: image, style: style, target: nil, action: #selector(pressed))
    self.target = self
    self._action = action
  }
  
  @objc private func pressed(sender: UIBarButtonItem) {
    _action?()
  }
}
