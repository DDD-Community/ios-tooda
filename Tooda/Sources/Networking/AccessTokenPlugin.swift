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
//		var request = request
//
//		if token.isNotEmpty {
//			request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//		}

    return request
  }
}
