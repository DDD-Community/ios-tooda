//
//  AppToken.swift
//  Tooda
//
//  Created by lyine on 2021/05/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

struct AppToken: Codable {
	var accessToken: String
	var refreshToken: String
}
