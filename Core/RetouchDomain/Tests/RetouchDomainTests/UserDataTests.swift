import Foundation
import Testing
@testable import RetouchDomain

@Suite(.tags(.model))
struct UserDataTests {
    
    @Test
    func decodesValidUserDataJSON() throws {
        let json = """
        {
            "token": "abc123",
            "user": {
                "id": "u1",
                "deviceId": "device001",
                "appleUserId": null,
                "fullName": "Alice Example",
                "email": "alice@example.com",
                "gemCount": 10,
                "freeGemCreditCount": 2,
                "fcmToken": "fcm_token_123"
            }
        }
        """.data(using: .utf8)!
        
        let data = try JSONDecoder().decode(UserData.self, from: json)
        
        #expect(data.token == "abc123")
        #expect(data.user.id == "u1")
        #expect(data.user.deviceId == "device001")
        #expect(data.user.appleUserId == nil)
        #expect(data.user.fullName == "Alice Example")
        #expect(data.user.email == "alice@example.com")
        #expect(data.user.gemCount == 10)
        #expect(data.user.freeGemCreditCount == 2)
        #expect(data.user.fcmToken == "fcm_token_123")
    }
    
    @Test
    func decodingFailsWhenUserMissing() {
        let json = """
        {
            "token": "abc123"
        }
        """.data(using: .utf8)!
        
        #expect(throws: DecodingError.self, performing: {
            try JSONDecoder().decode(UserData.self, from: json)
        })
    }
    
    @Test
    func decodingFailsWhenTokenMissing() {
        let json = """
            {
                "user": {
                    "id": "u1",
                    "deviceId": null,
                    "appleUserId": null,
                    "fullName": null,
                    "email": null,
                    "gemCount": 0,
                    "freeGemCreditCount": null,
                    "fcmToken": null
                }
            }
            """.data(using: .utf8)!
        
        #expect(throws: DecodingError.self, performing: {
            try JSONDecoder().decode(UserData.self, from: json)
        })
    }
    
    @Test
    func emptyUserData_hasExpectedDefaults() {
        let empty = UserData.empty
        
        #expect(empty.token == "")
        #expect(empty.user.id == "")
        #expect(empty.user.deviceId == nil)
        #expect(empty.user.appleUserId == nil)
        #expect(empty.user.fullName == nil)
        #expect(empty.user.email == nil)
        #expect(empty.user.gemCount == 0)
        #expect(empty.user.freeGemCreditCount == nil)
        #expect(empty.user.fcmToken == nil)
    }
}
