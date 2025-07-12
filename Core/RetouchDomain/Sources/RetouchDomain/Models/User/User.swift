import Foundation

public struct User: Decodable, Sendable {
    public let id: String
    public let deviceId: String?
    public let appleUserId: String?
    public let fullName: String?
    public let email: String?
    public let gemCount: Int
    public let freeGemCreditCount: Int?
    public let fcmToken: String?
    
    public init(
        id: String,
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
}

public extension User {
    var isLoginedWithAppleOrEmail: Bool {
        isLoginedWithApple || isLoginedWithEmail
    }
    
    var isLoginedWithApple: Bool {
        !(appleUserId?.isEmpty ?? true)
    }
    
    var isLoginedWithEmail: Bool {
        !isLoginedWithApple && !(email?.isEmpty ?? true)
    }
}

// MARK: - Empty
public extension User {
    static var empty: User {
        User(
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
