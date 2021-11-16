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
  case create(diary: Note)
  case list(limit: Int, cursor: Int)
  case delete(id: String)
  case addImage(data: Data)
  // TODO: update는 서버 스펙 전달 받는대로
}

extension NoteAPI: BaseAPI {
  var path: String {
    switch self {
      case .create:
        return "/diary"
      case .list:
        return "diary"
      case .addImage:
        return "diary/image"
      case .delete(let id):
        return "/diary/\(id)"
    }
  }
  
  var method: Moya.Method {
    switch self {
      case .create, .addImage:
        return .post
      case .list:
        return .get
      case .delete:
        return .delete
    }
  }
  
  var task: Task {
    guard let parameters = parameters else { return .requestPlain }
    var body: [String: Any] = [:]
    
    switch self {
      case .create(let note):
        // TODO: diary 파라미터 작성
        return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.default, urlParameters: parameters)
      case .addImage(let imageData):
        let imageData = MultipartFormData(provider: .data(imageData), name: "files", fileName: "image.jpeg", mimeType: "image/jpeg")
        let multipartData = [imageData]
        
        return .uploadMultipart(multipartData)
      case .list, .delete:
        return .requestParameters(parameters: parameters, encoding: parameterEncoding)
    }
  }
  
  var parameters: [String: Any]? {
    
    let defaultParameters: [String: Any] = [:]
    
    var parameters: [String: Any] = defaultParameters
    
    switch self {
    case .create, .delete, .addImage:
      return parameters
    case let .list(limit, cursor):
      parameters["limit"] = limit
      parameters["cursor"] = cursor
      return parameters
    }
  }
  
  var parameterEncoding: ParameterEncoding {
    switch self {
      case .create, .delete, .addImage:
        return JSONEncoding.default
      case .list:
        return URLEncoding.queryString
    }
  }
}
