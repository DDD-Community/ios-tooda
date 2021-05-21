//
//  DiaryAPI.swift
//  Tooda
//
//  Created by lyine on 2021/05/21.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import Moya

enum DiaryAPI {
	case create(diary: Diary)
	case list(limit: Int, cursor: Int)
	case delete(id: String)
	//TODO: update는 서버 스펙 전달 받는대로
}

extension DiaryAPI: BaseAPI {
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
		var body: [String: Any] = [:]
		
		switch self {
			case .create(let diary):
				//TODO: diary 파라미터 작성
				return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.default, urlParameters: parameters)
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
			case .create, .delete:
				return JSONEncoding.default
			case .list:
				return URLEncoding.queryString
		}
	}
}
