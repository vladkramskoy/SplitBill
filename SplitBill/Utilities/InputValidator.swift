//
//  InputValidator.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 28.10.2025.
//

import Foundation

final class InputValidator {
    static func formatCurrencyInput(_ input: String) -> String {
        if input.count > 10 {
            return String(input.prefix(10))
        }
        
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        let allowedCharacters = CharacterSet(charactersIn: "0123456789" + decimalSeparator)
        
        let filtered = input.filter { char in
            let stringChar = String(char)
            return stringChar.rangeOfCharacter(from: allowedCharacters) != nil
        }
        
        let normalized = filtered.replacingOccurrences(of: decimalSeparator == "." ? "," : ".", with: decimalSeparator)
        let components = normalized.components(separatedBy: decimalSeparator)
        
        if components.count > 2 {
            let firstPart = components[0]
            let remaining = components[1...].joined()
            return firstPart + decimalSeparator + remaining
        }
        
        if components.count == 2 {
            let integerPart = components[0]
            let fractionalPart = String(components[1].prefix(2))
            return integerPart + decimalSeparator + fractionalPart
        }
        
        return normalized
    }
}
