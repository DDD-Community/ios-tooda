//
//  BaseAPI.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import Moya
import Foundation

protocol BaseAPI: TargetType { }

enum BaseApiError: Error {
  case message(String)
}

extension BaseAPI {
  var baseURL: URL {
    guard let url = URL(string: baseUrl()) else { fatalError("Bad URL Request") }
    return url
  }

  var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }

  var sampleData: Data {
    guard let data = "Data".data(using: String.Encoding.utf8) else { return Data() }
    return data
  }
}

extension BaseApiError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .message(let message):
      return NSLocalizedString(message, comment: "serverError")
    }
  }
}
