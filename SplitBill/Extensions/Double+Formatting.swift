//
//  Double+Formatting.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 29.10.2025.
//

import Foundation

extension Double {
    var decimalFormatted: String {
        DecimalFormatter().format(self)
    }
    
    var currencyFormatted: String {
        "\(decimalFormatted) ₽"
    }
}
