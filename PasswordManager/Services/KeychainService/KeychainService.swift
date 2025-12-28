import CryptoKit
import Foundation
import Security

final class KeychainService {

    private let keyTag = "com.passwordmanager.encryptionkey"

    func getOrCreateKey() throws -> SymmetricKey {

        if let existingKey = try fetchKey() {
            return existingKey
        }

        let newKey = SymmetricKey(size: .bits256)
        try storeKey(newKey)
        return newKey
    }

    private func fetchKey() throws -> SymmetricKey? {

        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyTag,
            kSecReturnData as String: true,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess,
            let keyData = result as? Data
        else {
            throw KeychainError.unableToFetchKey
        }

        return SymmetricKey(data: keyData)
    }

    private func storeKey(_ key: SymmetricKey) throws {

        let keyData = key.withUnsafeBytes { Data($0) }

        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyTag,
            kSecValueData as String: keyData,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw KeychainError.unableToStoreKey
        }
    }
}

enum KeychainError: Error {
    case unableToFetchKey
    case unableToStoreKey
}
