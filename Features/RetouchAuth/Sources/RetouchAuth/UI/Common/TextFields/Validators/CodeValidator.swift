import Foundation

public struct CodeValidator: ValidatorProtocol {
    public init() {}
    
    public func validate(_ object: String?) -> ValidationResult {
        guard let string = object, !string.isEmpty else {
            return .noResult
        }
        
        if string.count < 6 {
            return .error("Code is not valid")
        }
        
        return .success
    }
}
