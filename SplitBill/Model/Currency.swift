//
//  Currency.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 13.03.2026.
//

import Foundation

struct Currency: Identifiable, Hashable {
    let code: String
    
    var id: String { code }
    
    var localizedName: String {
        let name = Locale.current.localizedString(forCurrencyCode: code) ?? code
        return name.prefix(1).uppercased() + name.dropFirst()
    }
}

extension Currency {
    static let popular: [Currency] = [
        Currency(code: "USD"),
        Currency(code: "EUR"),
        Currency(code: "RUB"),
        Currency(code: "GBP"),
        Currency(code: "TRY"),
        Currency(code: "THB"),
        Currency(code: "AED"),
        Currency(code: "JPY"),
        Currency(code: "IDR"),
        Currency(code: "CNY"),
        Currency(code: "KZT"),
        Currency(code: "GEL")
    ]
    
    static let all: [Currency] = Locale.commonISOCurrencyCodes
        .map { Currency(code: $0) }
        .filter { currency in
            !popular.contains(where: { $0.code == currency.code })
        }
        .sorted { $0.localizedName < $1.localizedName }
}
