//
//  UIImage+Extension.swift
//  Tooda
//
//  Created by Lyine on 2022/02/02.
//

import UIKit

extension UIImage {
  // 이미지의 사이즈를 width 비율에 맞게 변경
  func resizeImage(width: CGFloat) -> UIImage {
    let scale = width / self.size.width
    let newHeight = self.size.height * scale
    UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: newHeight), false, 0)
    self.draw(in: CGRect(x: 0, y: 0, width: width, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let newSizeImage = newImage else { return UIImage() }
    return newSizeImage
  }
}
