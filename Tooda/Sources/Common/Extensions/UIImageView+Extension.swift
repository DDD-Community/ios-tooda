//
//  UIImageView+Extension.swift
//  Tooda
//
//  Created by 황재욱 on 2022/02/05.
//

import UIKit

fileprivate let imageCache = NSCache<NSString, UIImage>().then {
  $0.countLimit = 1000
}

extension UIImageView {
  
  func load(url: URL) {
    if let image = imageCache.object(forKey: url.lastPathComponent as NSString) {
      self.image = image
    } else {
      URLSession.shared.dataTask(with: url) { data, _, error in
        guard let data = data, error == nil,
              let image = UIImage(data: data) else {
          return
        }
        
        imageCache.setObject(
          image,
          forKey: url.lastPathComponent as NSString
        )
        
        DispatchQueue.main.async { [weak self] in
          self?.image = image
        }
      }.resume()
    }
  }
}
