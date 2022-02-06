//
//  AppAppearance.swift
//  Tooda
//
//  Created by jinsu on 2021/05/23.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

final class AppApppearance {
  
  enum NavigationBarStyle {
    case normal
    case clear
    case white
    
    var tintColor: UIColor {
      return .black
    }
    
    var barTintColor: UIColor? {
      switch self {
      case .white:
        return .white
      case .clear:
        return nil
      case .normal:
        return nil
      }
    }
    
    var isTranslucent: Bool {
      switch self {
      case .clear, .white:
        return false
      case .normal:
        return true
      }
    }
    
    var backButtonImage: UIImage? {
      return UIImage(type: .backBarButton)
    }
    
    var shadowImage: UIImage? {
      switch self {
      case .clear, .white:
        return UIImage()
      case .normal:
        return nil
      }
    }
    
    var backgroundImage: UIImage? {
      switch self {
      case .clear, .white:
        return UIImage()
      case .normal:
        return nil
      }
    }
  }
  
  static func configureAppearance() {
    let navigationbar = UINavigationBar.appearance()
    let style: NavigationBarStyle = .clear
    
    navigationbar.tintColor = style.tintColor
    navigationbar.setBackgroundImage(style.backgroundImage, for: .default)
    navigationbar.shadowImage = style.shadowImage
    navigationbar.backItem?.title = ""
    navigationbar.backIndicatorImage = style.backButtonImage
    navigationbar.backIndicatorTransitionMaskImage = style.backButtonImage
    navigationbar.isTranslucent = style.isTranslucent
    navigationbar.barTintColor = style.barTintColor
  }
  
  static func updateNavigaionBarAppearance(_ navigationbar: UINavigationBar?, with style: NavigationBarStyle) {
    navigationbar?.tintColor = style.tintColor
    navigationbar?.setBackgroundImage(style.backgroundImage, for: .default)
    navigationbar?.shadowImage = style.shadowImage
    navigationbar?.backIndicatorImage = style.backButtonImage
    navigationbar?.backIndicatorTransitionMaskImage = style.backButtonImage
    navigationbar?.isTranslucent = style.isTranslucent
    navigationbar?.barTintColor = style.barTintColor
  }
}
