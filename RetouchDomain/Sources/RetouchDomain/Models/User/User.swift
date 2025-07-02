//
//  User.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 12.11.2020.
//

import Foundation
import Combine

public final class User: Decodable, @unchecked Sendable {
    // MARK: - Properties
    public var id: String
    public var deviceId: String?
    public var appleUserId: String?
    public var fullName: String?
    public var email: String?
    @Published public var gemCount: Int {
        didSet { saveDataToKeychainService() }
    }
    public var freeGemCreditCount: Int?
    public var fcmToken: String?
    
    public var isLoginedWithAppleOrEmail: Bool {
        isLoginedWithApple || isLoginedWithEmail
    }
    
    public var isLoginedWithApple: Bool {
        !(appleUserId?.isEmpty ?? true)
    }
    
    public var isLoginedWithEmail: Bool {
        !isLoginedWithApple && !(email?.isEmpty ?? true)
    }

    // CodingKeys
    private enum CodingKeys: String, CodingKey {
        case id, deviceId, appleUserId, fullName, email, gemCount, freeGemCreditCount, fcmToken
    }

    // MARK: - Inits
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? container.decode(String.self, forKey: .id)) ?? ""
        deviceId = try? container.decode(String?.self, forKey: .deviceId)
        appleUserId = try? container.decode(String?.self, forKey: .appleUserId)
        fullName = try? container.decode(String?.self, forKey: .fullName)
        email = try? container.decode(String?.self, forKey: .email)
        gemCount = (try? container.decode(Int.self, forKey: .gemCount)) ?? 0
        freeGemCreditCount = (try? container.decode(Int.self, forKey: .freeGemCreditCount)) ?? 0
        fcmToken = try? container.decode(String?.self, forKey: .fcmToken)
    }

    public init(id: String,
                deviceId: String?,
                appleUserId: String?,
                fullName: String?,
                email: String?,
                gemCount: Int,
                freeGemCreditCount: Int?,
                fcmToken: String?
    ) {
        self.id = id
        self.deviceId = deviceId
        self.appleUserId = appleUserId
        self.fullName = fullName
        self.email = email
        self.gemCount = gemCount
        self.freeGemCreditCount = freeGemCreditCount
        self.fcmToken = fcmToken
    }

    func update(by user: User) {
        self.id = user.id
        self.deviceId = user.deviceId
        self.appleUserId = user.appleUserId
        self.fullName = user.fullName
        self.email = user.email
        self.gemCount = user.gemCount
        self.freeGemCreditCount = user.freeGemCreditCount
        self.fcmToken = user.fcmToken
    }
}

// MARK: - Empty
public extension User {
    static var empty: User {
        return User(
            id: "",
            deviceId: nil,
            appleUserId: nil,
            fullName: nil,
            email: nil,
            gemCount: 0,
            freeGemCreditCount: nil,
            fcmToken: nil
        )
    }
}

// MARK: - KeychainService
extension User {
    func saveDataToKeychainService() {
        KeychainService.save(key: Constants.userId, value: id)
        KeychainService.save(key: Constants.deviceId, value: deviceId ?? "")
        KeychainService.save(key: Constants.appleUserId, value: appleUserId ?? "")
        KeychainService.save(key: Constants.fullName, value: fullName ?? "")
        KeychainService.save(key: Constants.email, value: email ?? "")
        KeychainService.save(key: Constants.gemCount, value: String(gemCount))
        KeychainService.save(key: Constants.freeGemCreditCount, value: String(freeGemCreditCount ?? 0))
        KeychainService.save(key: Constants.fcmToken, value: fcmToken ?? "")
    }

    func readDataFromKeychainService() {
        id = KeychainService.load(key: Constants.userId) ?? ""
        deviceId = KeychainService.load(key: Constants.deviceId) ?? ""
        appleUserId = KeychainService.load(key: Constants.appleUserId) ?? ""
        fullName = KeychainService.load(key: Constants.fullName) ?? ""
        email = KeychainService.load(key: Constants.email) ?? ""
        gemCount = Int(KeychainService.load(key: Constants.gemCount) ?? "0") ?? 0
        freeGemCreditCount = Int(KeychainService.load(key: Constants.freeGemCreditCount) ?? "0") ?? 0
        fcmToken = KeychainService.load(key: Constants.fcmToken) ?? ""
    }

    func removeDataFromKeychainService() {
        KeychainService.remove(key: Constants.userId)
        KeychainService.remove(key: Constants.deviceId)
        KeychainService.remove(key: Constants.appleUserId)
        KeychainService.remove(key: Constants.fullName)
        KeychainService.remove(key: Constants.email)
        KeychainService.remove(key: Constants.gemCount)
        KeychainService.remove(key: Constants.freeGemCreditCount)
        KeychainService.remove(key: Constants.fcmToken)
    }
}

struct Constants {
    public static let token = "token"
    public static let fcmToken = "fcmToken"
    public static let userId = "userId"
    public static let email = "email"
    public static let fullName = "fullName"
    public static let deviceId = "deviceId"
    public static let appleUserId = "appleUserId"
    public static let gemCount = "gemCount"
    public static let freeGemCreditCount = "freeGemCreditCount"
}
