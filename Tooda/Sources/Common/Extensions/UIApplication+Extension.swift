//
//  UIApplication+Extension.swift
//  Tooda
//
//  Created by 황재욱 on 2021/11/25.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

extension UIApplication {
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
