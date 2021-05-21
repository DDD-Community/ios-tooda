//
//  ColorAPI.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import Moya

enum ColorAPI {
	case colorList
}

extension ColorAPI: BaseAPI {
	var path: String {
		switch self {
			case .colorList:
				return "API/colors.json"
		}
	}
		
	var method: Moya.Method {
		switch self {
			case .colorList:
				return .get
		}
	}
	
	var task: Task {
		guard let parameters = parameters else { return .requestPlain }
//		var body: [String: Any] = [:]
		
		switch self {
			case .colorList:
				return .requestParameters(parameters: parameters, encoding: parameterEncoding)
				
		}
	}
	
	var parameters: [String: Any]? {
		
		let defaultParameters: [String: Any] = [:]
		
		let parameters: [String: Any] = defaultParameters
		
		switch self {
			case .colorList:
				return parameters
		}
	}
	
	var parameterEncoding: ParameterEncoding {
		switch self {
			case .colorList:
				return URLEncoding.queryString
		}
	}
}
