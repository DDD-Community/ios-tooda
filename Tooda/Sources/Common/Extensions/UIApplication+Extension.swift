//
//  UIApplication+Extension.swift
//  Tooda
//
//  Created by 황재욱 on 2021/11/25.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

extension UIApplication {
  static var keyWindow: UIWindow? {
    return shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
  }
  
  var statusBarUIView: UIView? {
    let tag = 38482458385
    if let statusBar = windows.first?.viewWithTag(tag) {
      return statusBar
    } else {
      if let statusBarFrame = windows.first?.windowScene?.statusBarManager?.statusBarFrame {
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.tag = tag
        windows.first?.addSubview(statusBarView)
        return statusBarView
      } else {
        return nil
      }
    }
  }
}
