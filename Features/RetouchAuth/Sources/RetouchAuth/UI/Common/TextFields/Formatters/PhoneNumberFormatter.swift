import Foundation

private struct PhoneNumberSymbolReference {
    static let number: Character = "n"
    static let leadingSymbol: Character = "+"
    static let countryCodeSeparator = " "
}

public struct PhoneNumberFormatter: FormatterProtocol {
    private let format = PhoneNumberFormat()
    private var includeCountryCode = true
    private var includePlusSymbol = true
    
    public func format(_ input: String) -> String {
        var normalizedInput = clean(input)

        var result = ""
        if normalizedInput.isEmpty {
            return result
        } else if normalizedInput.count > format.numberOfDigits {
            normalizedInput = String(normalizedInput.dropLast(normalizedInput.count - format.numberOfDigits))
        }
        
        var formattedPhoneNumber = ""
        var index = normalizedInput.startIndex
        
        for character in format.numberFormat {
            var shouldBreak = false
            if index < normalizedInput.endIndex {
                if character == PhoneNumberSymbolReference.number {
                    formattedPhoneNumber.append(normalizedInput[index])
                    
                    index = normalizedInput.index(after: index)
                }
            } else {
                shouldBreak = true
            }
            
            if character != PhoneNumberSymbolReference.number {
                formattedPhoneNumber.append(character)
            }
            
            if shouldBreak {
                break
            }
        }
        
        if includeCountryCode {
            var prefix = ""
            if includePlusSymbol {
                prefix.append(PhoneNumberSymbolReference.leadingSymbol)
            }
            
            prefix.append(format.countryCode)
            prefix.append(PhoneNumberSymbolReference.countryCodeSeparator)
            
            formattedPhoneNumber = prefix + formattedPhoneNumber
        }
        
        return formattedPhoneNumber
    }
    
    public func clean(_ value: String) -> String {
        let format = PhoneNumberFormat()
        var result = value.replacingOccurrences(of: "[^0-9 ]", with: "", options: .regularExpression)
        if result.hasPrefix(format.countryCode) {
            result = String(result.dropFirst(format.countryCode.count))
        }
        
        return result
    }
}

struct PhoneNumberFormat {
    let numberFormat = "(nnn) nnn-nnnn"
    let countryCode = "1"
    let numberOfDigits = 10
}
