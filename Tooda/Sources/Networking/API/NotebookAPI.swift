//
//  NotebookAPI.swift
//  Tooda
//
//  Created by Jinsu Park on 2021/07/31.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import Moya

enum NotebookAPI {
  case meta(year: Int)
}

extension NotebookAPI: BaseAPI {

  var path: String {
    switch self {
    case .meta(let year):
      return "diary/\(year)/metas"
    }
  }

  var method: Moya.Method {
    switch self {
    case .meta:
      return .get
    }
  }

  var parameters: [String: Any]? {

    let defaultParameters: [String: Any] = [:]

    let parameters: [String: Any] = defaultParameters

    switch self {
    case .meta:
      return parameters
    }
  }

  var parameterEncoding: ParameterEncoding {
    switch self {
    case .meta:
      return URLEncoding.queryString
    }
  }

  var task: Task {
    guard let parameters = parameters else { return .requestPlain }
    var body: [String: Any] = [:]

    switch self {
    case .meta:
      return .requestParameters(parameters: parameters, encoding: parameterEncoding)
    }
  }
}
