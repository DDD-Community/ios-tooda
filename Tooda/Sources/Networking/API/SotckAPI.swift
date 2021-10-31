  //
  //  SotckAPI.swift
  //  Tooda
  //
  //  Created by Lyine on 2021/10/31.
  //  Copyright © 2021 DTS. All rights reserved.
  //

import Moya

enum StockAPI {
  case search(keyword: String)
}

extension StockAPI: BaseAPI {
  var path: String {
    switch self {
      case .search:
        return "/stock/search"
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
        return .requestParameters(parameters: parameters, encoding: parameterEncoding)
    }
  }
  
  var parameters: [String: Any]? {
    
    let defaultParameters: [String: Any] = [:]
    
    let parameters: [String: Any] = defaultParameters
    
    switch self {
      case .search(let keyword):
        
        var parameters = parameters
        
        parameters.concat(
          dict: [
            "q": keyword
          ])
        
        return parameters
    }
  }
  
  var parameterEncoding: ParameterEncoding {
    switch self {
      case .search:
        return URLEncoding.queryString
    }
  }
}
