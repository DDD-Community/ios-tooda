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

  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {

//		let token = AppManager.shared.accessToken
//		let keychain = Keychain()
//
		var request = request
    
    let token = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiZGV2aWNlSWQiOiJCQTBGODFFQi05RkY4LTQ5OEEtODYyMy1EMjVCMTQ2QzhFNUUiLCJpYXQiOjE2MjIwNzM2NTMsImV4cCI6MTYyMjE2MDA1M30.cCaYGVDTeCdDVw1zis4y--hMeHVXr0rOTaWX70ebZVU"
    
    request.addValue(token, forHTTPHeaderField: "Authorization")

    return request
  }
}
