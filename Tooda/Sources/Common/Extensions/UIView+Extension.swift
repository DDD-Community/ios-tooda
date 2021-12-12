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

extension UIView {
  func generateGradient(colors: [UIColor], locations: [NSNumber] = [0, 1], startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) -> CAGradientLayer {
    let gradient: CAGradientLayer = CAGradientLayer()
    gradient.frame = self.bounds
    gradient.colors = colors.map { $0.cgColor }
    gradient.startPoint = startPoint
    gradient.endPoint = endPoint
    gradient.locations = locations
    
    return gradient
  }
}
