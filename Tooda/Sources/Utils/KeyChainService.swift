//
//  KeyChainService.swift
//  Tooda
//
//  Created by 황재욱 on 2021/07/10.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation
import Security

extension LocalPersistanceManager {
  final class KeyChainService: LocalPersistenceServiceType {
    
    func value<T>(forKey key: LocalPersistenceKey) -> T? {
      let query = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key.rawValue,
        kSecAttrService as String: key.rawValue,
        kSecReturnData as String: kCFBooleanTrue,
        kSecMatchLimit as String: kSecMatchLimitOne
      ] as [String: Any?]

      var keyChainFetchedRef: AnyObject?

      let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &keyChainFetchedRef)

      return status == noErr ? keyChainFetchedRef as? T : nil
    }
    
    func set<T>(value: T?, forKey key: LocalPersistenceKey) {
      let query = [
        kSecClass as String: kSecClassGenericPassword as String,
        kSecAttrAccount as String: key.rawValue,
        kSecAttrService as String: key.rawValue,
        kSecValueData as String: value
      ] as [String: Any?]

      SecItemDelete(query as CFDictionary)
      SecItemAdd(query as CFDictionary, nil)
    }
    
    func objectValue<T>(forKey key: LocalPersistenceKey) -> T? where T: Decodable, T: Encodable {
      let data: Data? = value(forKey: key)
      let decoder = JSONDecoder()
      guard let unwrappedData = data,
            let decodedData = try? decoder.decode(T.self, from: unwrappedData) else { return nil }
      return decodedData
    }
    
    func setObject<T>(value: T?, forKey key: LocalPersistenceKey) where T: Decodable, T: Encodable {
      let encoder = JSONEncoder()
      guard let encodedData = try? encoder.encode(value) else {
        return
      }
      set(value: encodedData, forKey: key)
    }
    
    func delete(forKey key: LocalPersistenceKey) {
      let query = [
        kSecClass as String: kSecClassGenericPassword as String,
        kSecAttrAccount as String: key.rawValue,
        kSecAttrService as String: key.rawValue,
      ] as [String: Any?]

      SecItemDelete(query as CFDictionary)
      SecItemAdd(query as CFDictionary, nil)
    }
  }
}
