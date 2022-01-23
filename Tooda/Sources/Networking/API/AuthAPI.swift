//
//  AuthAPI.swift
//  Tooda
//
//  Created by lyine on 2021/05/21.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import Moya

enum AuthAPI {
  case signUp(token: String)
  case refresh(refreshToken: String)
}

extension AuthAPI: BaseAPI {
  var path: String {
    switch self {
    case .signUp:
      return "auth/sign-up/apple"
    case .refresh:
      return "/auth/refresh"
    }
  }

  var method: Moya.Method {
    switch self {
    case .signUp, .refresh:
      return .post
    }
  }

  var task: Task {
    guard let parameters = parameters else { return .requestPlain }
    var body: [String: Any] = [:]

    switch self {
    case .signUp(let token):

      body.concat(dict: ["identityToken": token])

      return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.default, urlParameters: parameters)
    case .refresh(let refreshToken):

      body.concat(dict: ["refreshToken": refreshToken])

      return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.default, urlParameters: parameters)
    }
  }

  var parameters: [String: Any]? {

    let defaultParameters: [String: Any] = [:]

    let parameters: [String: Any] = defaultParameters

    switch self {
    case .signUp, .refresh:
      return parameters
    }
  }

  var parameterEncoding: ParameterEncoding {
    switch self {
    case .signUp, .refresh:
      return JSONEncoding.default
    }
  }
}
