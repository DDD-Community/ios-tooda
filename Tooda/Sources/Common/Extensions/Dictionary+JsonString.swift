//
//  Dictionary+JsonString.swift
//  Tooda
//
//  Created by lyine on 2021/05/26.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

extension Dictionary {
  var jsonStringRepresentation: String? {
    guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                        options: [.prettyPrinted]) else {
      return nil
    }
    
    return String(data: theJSONData, encoding: .utf8)
  }
}
