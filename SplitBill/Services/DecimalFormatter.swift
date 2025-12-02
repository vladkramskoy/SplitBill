//
//  NumberFormatter.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 25.10.2025.
//

import Foundation

protocol DecimalFormatting {
    func format(_ amount: Double) -> String
    func parse(_ string: String) -> Double?
}

final class DecimalFormatter: DecimalFormatting {
    private let formatter: NumberFormatter
    
    init(locale: Locale = .current) {
        formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        formatter.maximumFractionDigits = 2
        formatter.minimum = 0
    }
    
    func format(_ amount: Double) -> String {
        formatter.string(from: NSNumber(value: amount)) ?? ""
    }
    
    func parse(_ string: String) -> Double? {
        formatter.number(from: string)?.doubleValue
    }
}
