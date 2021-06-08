//
//  UserDefaultsService.swift
//  Tooda
//
//  Created by lyine on 2021/05/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

enum UserDefaultsKey: String {
	case firstLaunch
	case searchHistory
	case appToken
}

protocol UserDefaultsServiceType {
	func value<T>(forKey key: UserDefaultsKey) -> T?
	func set<T>(value: T?, forKey key: UserDefaultsKey)
	
	func objectValue<T: Codable>(forKey key: UserDefaultsKey) -> T?
	func setObject<T: Codable>(value: T?, forKey key: UserDefaultsKey)
}

final class UserDefaultsService: UserDefaultsServiceType {
	
	private var defaults: UserDefaults {
		return UserDefaults.standard
	}
	
	func value<T>(forKey key: UserDefaultsKey) -> T? {
		return self.defaults.value(forKey: key.rawValue) as? T
	}
	
	func set<T>(value: T?, forKey key: UserDefaultsKey) {
		self.defaults.set(value, forKey: key.rawValue)
	}
	
	func setObject<T: Codable>(value: T?, forKey key: UserDefaultsKey) {
		let encoder = JSONEncoder()
		guard let encodedData = try? encoder.encode(value) else {
			return
		}
		self.defaults.set(encodedData, forKey: key.rawValue)
	}
	
	func objectValue<T: Codable>(forKey key: UserDefaultsKey) -> T? {
		guard let storedValue = self.defaults.value(forKey: key.rawValue) as? Data else { return nil }
		
		let decoder = JSONDecoder()
		guard let decodedData = try? decoder.decode(T.self, from: storedValue) else { return nil }
		return decodedData
	}
}

