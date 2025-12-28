import CryptoKit
import Foundation

final class EncryptionService {

    private let secretKey: SymmetricKey

    init(secretKey: SymmetricKey) {
        self.secretKey = secretKey
    }

    func encrypt(password: String) throws -> Data {

        let passwordData = Data(password.utf8)

        let sealedBox = try AES.GCM.seal(passwordData, using: secretKey)

        return sealedBox.combined!
    }

    func decrypt(encryptedData: Data) throws -> String {

        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)

        let decryptedData = try AES.GCM.open(sealedBox, using: secretKey)

        return String(decoding: decryptedData, as: UTF8.self)
    }
}
