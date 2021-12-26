//
//  SearchAPI.swift
//  Tooda
//
//  Created by Jinsu Park on 2021/12/26.
//

import Foundation

import Moya

enum SearchAPI {
  case search(query: String, limit: Int)
}

extension SearchAPI: BaseAPI {
  var path: String {
    switch self {
    case .search:
      return "diary/search"
    }
  }

  var method: Moya.Method {
    switch self {
    case .search:
      return .get
    }
  }

  var task: Task {
    guard let parameters = parameters else { return .requestPlain }
    var body: [String: Any] = [:]

    switch self {
    case .search:
      return .requestParameters(
        parameters: parameters,
        encoding: parameterEncoding
      )
    }
  }

  var parameters: [String: Any]? {
    let defaultParameters: [String: Any] = [:]
    var parameters: [String: Any] = defaultParameters

    switch self {
    case let .search(query, limit):
      parameters["q"] = query
      parameters["limit"] = limit
    }

    return parameters
  }

  var parameterEncoding: ParameterEncoding {
    switch self {
    case .search:
      return URLEncoding.queryString
    }
  }
}
