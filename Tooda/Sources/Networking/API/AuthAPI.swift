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
  case deleteUser
}

extension AuthAPI: BaseAPI {
  var path: String {
    switch self {
    case .signUp:
      return "auth/sign-up/apple"
    case .refresh:
      return "/auth/refresh"
    case .deleteUser:
      return "user"
    }
  }

  var method: Moya.Method {
    switch self {
    case .signUp, .refresh:
      return .post
    case .deleteUser:
      return .delete
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
    case .deleteUser:
      return .requestPlain
    }
  }

  var parameters: [String: Any]? {

    let defaultParameters: [String: Any] = [:]

    let parameters: [String: Any] = defaultParameters

    switch self {
    case .signUp, .refresh:
      return parameters
    case .deleteUser:
      return nil
    }
  }

  var parameterEncoding: ParameterEncoding {
    switch self {
    case .signUp, .refresh, .deleteUser:
      return JSONEncoding.default
    }
  }
}
