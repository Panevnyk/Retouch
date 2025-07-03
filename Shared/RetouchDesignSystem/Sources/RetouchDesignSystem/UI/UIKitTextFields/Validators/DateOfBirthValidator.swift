//
//  DateOfBirthValidator.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 27.01.2021.
//

import Foundation
import RetouchUtils

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
