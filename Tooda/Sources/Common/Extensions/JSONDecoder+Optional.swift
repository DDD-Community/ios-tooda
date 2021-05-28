//
//  JSONDecoder+Optional.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

extension JSONDecoder {
  static func decodeOptional<T: Codable>(_ data: Data, type: T.Type) -> T? {
    do {
      return try JSONDecoder().decode(type, from: data)
    } catch {
      return nil
    }
  }

  static func decodeOptional<T: Codable>(_ dataString: String, type: T.Type) -> T? {
    guard let data = dataString.data(using: .utf8) else { return nil }

    do {
      return try JSONDecoder().decode(type, from: data)
    } catch let error {
			print(error)
      return nil
    }
  }
}
