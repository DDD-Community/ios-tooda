//
//  NoteAPI.swift
//  Tooda
//
//  Created by lyine on 2021/05/21.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import Moya

enum NoteAPI {
  case create(dto: RequestNoteDTO)
  case list(limit: Int, cursor: Int)
  case delete(id: String)
  // TODO: update는 서버 스펙 전달 받는대로
}

extension NoteAPI: BaseAPI {
  var path: String {
    switch self {
    case .create:
      return "/diary"
    case .list(let limit, let cursor):
      return "/diary?limit=\(limit)&cursor\(cursor)"
    case .delete(let id):
      return "/diary/\(id)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .create:
      return .post
    case .list:
      return .get
    case .delete:
      return .delete
    }
  }

  var task: Task {
    guard let parameters = parameters else { return .requestPlain }
    let body: [String: Any] = [:]

    switch self {
    case .create(let note):
      let formLists = note.asParameters()
      return .uploadMultipart(formLists)
      
    case .list, .delete:
      return .requestParameters(parameters: parameters, encoding: parameterEncoding)
    }
  }

  var parameters: [String: Any]? {

    let defaultParameters: [String: Any] = [:]

    let parameters: [String: Any] = defaultParameters

    switch self {
    case .create, .list, .delete:
      return parameters
    }
  }

  var parameterEncoding: ParameterEncoding {
    switch self {
    case .delete:
      return JSONEncoding.default
	case .create, .list:
      return URLEncoding.queryString
    }
  }
}
