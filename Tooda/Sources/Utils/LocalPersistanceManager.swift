//
//  LocalPersistanceManager.swift
//  Tooda
//
//  Created by 황재욱 on 2021/07/10.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

protocol LocalPersistanceManagerType {
  func value<T>(forKey key: LocalPersistenceKey) -> T?
  func set<T>(value: T?, forKey key: LocalPersistenceKey)
  func delete(forKey key: LocalPersistenceKey)
  
  func objectValue<T: Codable>(forKey key: LocalPersistenceKey) -> T?
  func setObject<T: Codable>(value: T?, forKey key: LocalPersistenceKey)
}

final class LocalPersistanceManager: LocalPersistanceManagerType {
  
  private let keyChainService: LocalPersistenceServiceType
  private let userDefaultService: LocalPersistenceServiceType
  
  init(
    keyChainService: LocalPersistenceServiceType,
    userDefaultService: LocalPersistenceServiceType
  ) {
    self.keyChainService = keyChainService
    self.userDefaultService = userDefaultService
  }
  
  func value<T>(forKey key: LocalPersistenceKey) -> T? {
    switch key {
    case .appToken:
      return keyChainService.value(forKey: key)
    default:
      return userDefaultService.value(forKey: key)
    }
  }
  
  func set<T>(value: T?, forKey key: LocalPersistenceKey) {
    switch key {
    case .appToken:
      return keyChainService.set(value: value, forKey: key)
    default:
      return userDefaultService.set(value: value, forKey: key)
    }
  }
  
  func objectValue<T: Codable>(forKey key: LocalPersistenceKey) -> T? {
    switch key {
    case .appToken:
      return keyChainService.objectValue(forKey: key)
    default:
      return userDefaultService.objectValue(forKey: key)
    }
  }
  
  func setObject<T: Codable>(value: T?, forKey key: LocalPersistenceKey) {
    switch key {
    case .appToken:
      return keyChainService.setObject(value: value, forKey: key)
    default:
      return userDefaultService.setObject(value: value, forKey: key)
    }
  }
  
  func delete(forKey key: LocalPersistenceKey) {
    switch key {
    case .appToken:
      return keyChainService.delete(forKey: key)
    default:
      return userDefaultService.delete(forKey: key)
    }
  }
}
