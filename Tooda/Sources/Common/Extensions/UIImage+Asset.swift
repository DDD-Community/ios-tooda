//
//  UIImage+Asset.swift
//  Tooda
//
//  Created by jinsu on 2021/05/23.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

enum AppImage: String {
  case backBarButton = "back"
  case searchBarButton = "search"
  case settingBarButton = "setting"
  case login = "login"
}

extension UIImage {
  
  convenience init?(type: AppImage) {
    self.init(named: type.rawValue)
  }
}
