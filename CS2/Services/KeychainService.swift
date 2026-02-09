//
//  KeychainService.swift
//  CS2
//

import Foundation
import Security

/// Сохранение и чтение данных из Keychain (локально на устройстве).
final class KeychainService {
    static let shared = KeychainService()
    private let serviceName = "com.cs2.lineups"

    private init() {}

    func save(key: String, value: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecValueData as String: value
        ]
        SecItemDelete(query as CFDictionary) // удалить старый, если есть
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func load(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return data
    }

    func remove(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
