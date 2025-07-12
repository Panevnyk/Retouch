import Foundation

public struct UserData: Decodable, Sendable {
    public let token: String
    public let user: User
    
    public init(token: String, user: User) {
        self.token = token
        self.user = user
    }
}

// MARK: - Empty
public extension UserData {
    static var empty: UserData {
        UserData(token: "", user: User.empty)
    }
}
