//
//  UserDefaultsService.swift
//  Tooda
//
//  Created by lyine on 2021/05/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

enum LocalPersistenceKey: String {
	case firstLaunch
	case searchHistory
	case appToken
}

enum LocalPersistenceType: String {
  case keyChain
  case userDefaults
}

protocol LocalPersistenceServiceType {
	func value<T>(forKey key: LocalPersistenceKey) -> T?
	func set<T>(value: T?, forKey key: LocalPersistenceKey)
	
	func objectValue<T: Codable>(forKey key: LocalPersistenceKey) -> T?
	func setObject<T: Codable>(value: T?, forKey key: LocalPersistenceKey)
}

extension LocalPersistanceManager {
  final class UserDefaultsService: LocalPersistenceServiceType {
    
    private var defaults: UserDefaults {
      return UserDefaults.standard
    }
    
    func value<T>(forKey key: LocalPersistenceKey) -> T? {
      return self.defaults.value(forKey: key.rawValue) as? T
    }
    
    func set<T>(value: T?, forKey key: LocalPersistenceKey) {
      self.defaults.set(value, forKey: key.rawValue)
    }
    
    func setObject<T: Codable>(value: T?, forKey key: LocalPersistenceKey) {
      let encoder = JSONEncoder()
      guard let encodedData = try? encoder.encode(value) else {
        return
      }
      self.defaults.set(encodedData, forKey: key.rawValue)
    }
    
    func objectValue<T: Codable>(forKey key: LocalPersistenceKey) -> T? {
      guard let storedValue = self.defaults.value(forKey: key.rawValue) as? Data else { return nil }
      
      let decoder = JSONDecoder()
      guard let decodedData = try? decoder.decode(T.self, from: storedValue) else { return nil }
      return decodedData
    }
  }
}
