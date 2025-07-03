import Foundation

public struct DateOfBirthValidator: ValidatorProtocol {
    public init() {}

    public func validate(_ object: String?) -> ValidationResult {
        guard let string = object, !string.isEmpty else {
            return .noResult
        }

        let dateFormatter = DateHelper.shared.dateStyleFormatter

        guard let _ = dateFormatter.date(from: string) else {
            return .error("Date of birth is not valid")
        }

        return .success
    }
}
