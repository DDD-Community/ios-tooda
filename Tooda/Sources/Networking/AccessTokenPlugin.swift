//
//  AccessTokenPlugin.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation
import Moya

final class AccessTokenPlugin: PluginType {
  
  let localPersistance: LocalPersistanceManagerType
  
  init(localPersistance: LocalPersistanceManagerType) {
    self.localPersistance = localPersistance
  }

  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {

    let token: AppToken? = localPersistance.objectValue(forKey: .appToken)

		var request = request
    
    if let accessToken = token?.accessToken, !accessToken.isEmpty {
      request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
		}

    return request
  }
}
