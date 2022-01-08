//
//  Array+Extension.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/18.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

extension Array {
  subscript (safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}

extension Collection {
  var isNotEmpty: Bool {
    return !self.isEmpty
  }
}
