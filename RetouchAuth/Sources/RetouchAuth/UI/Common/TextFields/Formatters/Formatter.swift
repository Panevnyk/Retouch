import Foundation

public protocol FormatterProtocol {
    func format(_ value: String) -> String
    func clean(_ value: String) -> String
}

extension FormatterProtocol {
    public func clean(_ value: String) -> String {
        return value
    }
}
