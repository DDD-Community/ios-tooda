//
//  UIApplication+Extension.swift
//  Tooda
//
//  Created by lyine on 2021/05/25.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

// MARK: - 최상위 뷰컨트롤러
extension UIApplication {
  static func topViewController(ViewController: UIViewController? =
                                  UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController) -> UIViewController? {
    
    if let tabBarViewController = ViewController as? UITabBarController {
      if let vc = tabBarViewController.selectedViewController {
        return topViewController(ViewController: vc)
      }
    }
    
    if let navigationViewController = ViewController as? UINavigationController {
      if let vc = navigationViewController.visibleViewController {
        return topViewController(ViewController: vc)
      }
    }
    
    if let presentedViewController = ViewController?.presentedViewController {
      return topViewController(ViewController: presentedViewController)
    }
    
    
    
    return ViewController
  }
}
