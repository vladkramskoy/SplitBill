//
//  NumberFormatter.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 25.10.2025.
//

import Foundation

protocol DecimalFormatting {
    func format(_ amount: Double) -> String
    func formatCompact(_ amount: Double) -> String
    func parse(_ string: String) -> Double?
    var currencySymbol: String { get }
}

final class DecimalFormatter: DecimalFormatting {
    private let formatter: NumberFormatter
    private let compactFormatter: NumberFormatter
    private let inputFormatter: NumberFormatter
    
    init(currencyCode: String = "RUB", locale: Locale = .current) {
        formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = locale
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        compactFormatter = NumberFormatter()
        compactFormatter.numberStyle = .currency
        compactFormatter.currencyCode = currencyCode
        compactFormatter.locale = locale
        compactFormatter.minimumFractionDigits = 0
        compactFormatter.maximumFractionDigits = 2
        
        inputFormatter = NumberFormatter()
        inputFormatter.numberStyle = .decimal
        inputFormatter.locale = locale
        inputFormatter.maximumFractionDigits = 2
        inputFormatter.minimum = 0
    }
    
    func format(_ amount: Double) -> String {
        formatter.string(from: NSNumber(value: amount)) ?? ""
    }
    
    func formatCompact(_ amount: Double) -> String {
        compactFormatter.string(from: NSNumber(value: amount)) ?? ""
    }
    
    func parse(_ string: String) -> Double? {
        inputFormatter.number(from: string)?.doubleValue
    }
    
    var currencySymbol: String {
        formatter.currencySymbol ?? ""
    }
}
