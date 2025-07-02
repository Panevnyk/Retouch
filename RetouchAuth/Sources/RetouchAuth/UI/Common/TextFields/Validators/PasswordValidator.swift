public struct PasswordValidator: ValidatorProtocol {
    public init() {}
    
    public func validate(_ object: String?) -> ValidationResult {
        guard let string = object, !string.isEmpty else {
            return .noResult
        }
        
        if string.count < 8 {
            return .error("Password is too short")
        }

        return .success
    }
}
