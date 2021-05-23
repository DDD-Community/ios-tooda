//
//  AppAppearance.swift
//  Tooda
//
//  Created by jinsu on 2021/05/23.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

final class AppApppearance {
  
  static func configureAppeance() {
    let navigationbar = UINavigationBar.appearance()
    let backImage = UIImage(type: .backBarButton)
    
    navigationbar.tintColor = .black
    navigationbar.setBackgroundImage(UIImage(), for: .default)
    navigationbar.shadowImage = UIImage()
    navigationbar.backgroundColor = .clear
    navigationbar.backItem?.title = ""
    navigationbar.backIndicatorImage = backImage
    navigationbar.backIndicatorTransitionMaskImage = backImage
  }
}
