//
//  UIViewController+Extension.swift
//  Tooda
//
//  Created by Lyine on 2021/09/18.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

extension UIViewController {
  func openAppSettingMenu() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}
