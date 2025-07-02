import SwiftUI
import Combine

public enum TextInputType {
    case `default`
    case name
    case email
    case password
    case number
    case phoneNumber
}

extension TextInputType {
    var formatter: FormatterProtocol {
        switch self {
        case .default, .name, .email:
            return TextFormatter()

        case .password:
            return TextFormatter()

        case .number:
            return TextFormatter()

        case .phoneNumber:
            return TextFormatter()
        }
    }

    var validator: ValidatorProtocol {
        switch self {
        case .default:
            return TextValidator()
            
        case .name:
            return TextValidator()
                
        case .email:
            return EmailValidator()

        case .password:
            return PasswordValidator()

        case .number:
            return TextValidator()

        case .phoneNumber:
            return PhoneNumberValidator()
        }
    }

    var keyboardType: UIKeyboardType {
        switch self {
        case .default, .name, .password:
            return .default

        case .phoneNumber, .number:
            return .numberPad

        case .email:
            return .emailAddress
        }
    }
}
