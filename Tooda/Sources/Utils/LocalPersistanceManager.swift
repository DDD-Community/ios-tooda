//
//  LocalPersistanceManager.swift
//  Tooda
//
//  Created by 황재욱 on 2021/07/10.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

enum LocalPersistanceManager {
  case userDefaults
  case keychain
  
  private static let keyChainService = KeyChainService()
  private static let userDefaultService = UserDefaultsService()
  
  private var service: LocalPersistenceServiceType {
    switch self {
    case .userDefaults:
      return LocalPersistanceManager.userDefaultService
    case .keychain:
      return LocalPersistanceManager.keyChainService
    }
  }
  
  func value<T>(forKey key: LocalPersistenceKey) -> T? {
    service.value(forKey: key)
  }
  
  func set<T>(value: T?, forKey key: LocalPersistenceKey) {
    service.set(value: value, forKey: key)
  }
  
  func objectValue<T: Codable>(forKey key: LocalPersistenceKey) -> T? {
    service.objectValue(forKey: key)
  }
  
  func setObject<T: Codable>(value: T?, forKey key: LocalPersistenceKey) {
    service.setObject(value: value, forKey: key)
  }
}
