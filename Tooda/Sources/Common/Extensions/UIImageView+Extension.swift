//
//  UIImageView+Extension.swift
//  Tooda
//
//  Created by 황재욱 on 2022/02/05.
//

import UIKit

extension UIImageView {
  func load(url: URL) {
    URLSession.shared.dataTask(with: url) { data, _, error in
      guard let data = data, error == nil else {
        return
      }
      
      DispatchQueue.main.async { [weak self] in
        self?.image = UIImage(data: data)
      }
    }.resume()
  }
}
