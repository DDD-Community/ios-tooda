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
  case create(dto: AddNoteDTO)
  case list(limit: Int, cursor: Int)
  case monthlyList(limit: Int?, cursor: Int?, year: Int, month: Int)
  case delete(id: String)
  case addImage(data: Data)
  // TODO: update는 서버 스펙 전달 받는대로
  case detail(id: String)
}

extension NoteAPI: BaseAPI {
  var path: String {
    switch self {
      case .create:
        return "diary"
      case .monthlyList:
        return "diary/date"
      case .list:
        return "diary"
      case .addImage:
        return "diary/image"
      case .delete(let id):
        return "/diary/\(id)"
      case .detail(let id):
        return "diary/\(id)"
    }
  }
  
  var method: Moya.Method {
    switch self {
      case .create, .addImage:
        return .post
      case .list, .monthlyList, .detail:
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
        
        body.concat(dict: note.asBodyParameters())
        
        return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.default, urlParameters: parameters)
      case .addImage(let imageData):
        let imageData = MultipartFormData(provider: .data(imageData), name: "files", fileName: "image.jpeg", mimeType: "image/jpeg")
        let multipartData = [imageData]
        
        return .uploadMultipart(multipartData)
      case .list, .delete, .monthlyList, .detail:
        return .requestParameters(parameters: parameters, encoding: parameterEncoding)
    }
  }
  
  var parameters: [String: Any]? {
    
    let defaultParameters: [String: Any] = [:]
    
    var parameters: [String: Any] = defaultParameters
    
    switch self {
    case .create, .delete, .addImage, .detail:
      return parameters
    case let .list(limit, cursor):
      parameters["limit"] = limit
      parameters["cursor"] = cursor
      return parameters
    case let .monthlyList(limit, cursor, year, month):
      if let limit = limit {
        parameters["limit"] = limit
      }
      
      if let cursor = cursor {
        parameters["cursor"] = cursor
      }
      
      parameters["year"] = year
      parameters["month"] = month
      return parameters
    }
  }
  
  var parameterEncoding: ParameterEncoding {
    switch self {
      case .create, .delete, .addImage:
        return JSONEncoding.default
      case .list, .monthlyList, .detail:
        return URLEncoding.queryString
    }
  }
}
