import Foundation
import Testing
@testable import RetouchDomain

@Suite(.tags(.model))
struct UserTests {
    
    @Test
    func decodesMinimalUser() throws {
        let json = """
        {
            "id": "123",
            "gemCount": 10
        }
        """.data(using: .utf8)!

        let user = try JSONDecoder().decode(User.self, from: json)

        #expect(user.id == "123")
        #expect(user.gemCount == 10)
        #expect(user.deviceId == nil)
        #expect(user.appleUserId == nil)
        #expect(user.fullName == nil)
        #expect(user.email == nil)
        #expect(user.freeGemCreditCount == nil)
        #expect(user.fcmToken == nil)
    }
    
    @Test
    func decodesFullUser() throws {
        let json = """
        {
            "id": "u1",
            "deviceId": "device123",
            "appleUserId": "apple123",
            "fullName": "Jane Appleseed",
            "email": "jane@apple.com",
            "gemCount": 42,
            "freeGemCreditCount": 3,
            "fcmToken": "token_abc"
        }
        """.data(using: .utf8)!

        let user = try JSONDecoder().decode(User.self, from: json)

        #expect(user.id == "u1")
        #expect(user.deviceId == "device123")
        #expect(user.appleUserId == "apple123")
        #expect(user.fullName == "Jane Appleseed")
        #expect(user.email == "jane@apple.com")
        #expect(user.gemCount == 42)
        #expect(user.freeGemCreditCount == 3)
        #expect(user.fcmToken == "token_abc")
    }
    
    @Test
    func loginState_whenAppleUserIdPresent_isAppleLoginTrue() {
        let user = User(
            id: "1",
            deviceId: nil,
            appleUserId: "apple-user",
            fullName: nil,
            email: nil,
            gemCount: 0,
            freeGemCreditCount: nil,
            fcmToken: nil
        )

        #expect(user.isLoginedWithApple)
        #expect(!user.isLoginedWithEmail)
        #expect(user.isLoginedWithAppleOrEmail)
    }

    @Test
    func loginState_whenOnlyEmailPresent_isEmailLoginTrue() {
        let user = User(
            id: "2",
            deviceId: nil,
            appleUserId: nil,
            fullName: nil,
            email: "user@example.com",
            gemCount: 0,
            freeGemCreditCount: nil,
            fcmToken: nil
        )

        #expect(!user.isLoginedWithApple)
        #expect(user.isLoginedWithEmail)
        #expect(user.isLoginedWithAppleOrEmail)
    }

    @Test
    func loginState_whenNoCredentials_isAllLoginFalse() {
        let user = User.empty

        #expect(!user.isLoginedWithApple)
        #expect(!user.isLoginedWithEmail)
        #expect(!user.isLoginedWithAppleOrEmail)
    }

    @Test
    func emptyUser_hasExpectedDefaults() {
        let user = User.empty

        #expect(user.id == "")
        #expect(user.deviceId == nil)
        #expect(user.appleUserId == nil)
        #expect(user.fullName == nil)
        #expect(user.email == nil)
        #expect(user.gemCount == 0)
        #expect(user.freeGemCreditCount == nil)
        #expect(user.fcmToken == nil)
    }
}
