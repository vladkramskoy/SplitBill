//
//  SplitBillTests.swift
//  SplitBillTests
//
//  Created by Vlad Kramskoy on 27.10.2025.
//

import Testing
import Foundation
@testable import SplitBill

struct SplitBillTests {
    
    let usFormatter = DecimalFormatter(locale: Locale(identifier: "en_US"))
    let ruFormatter = DecimalFormatter(locale: Locale(identifier: "ru_RU"))
    
    @Test func formattingInUSLocale() {
        #expect(usFormatter.format(1234.56) == "1,234.56")
    }
    
    @Test func formattingInRussianLocale() {
        #expect(ruFormatter.format(1234.56) == "1 234,56")
    }
    
    @Test func parsingInUSLocale() {
        #expect(usFormatter.parse("1,234.56") == 1234.56)
    }
    
    @Test func parsingInRussianLocale() {
        #expect(ruFormatter.parse("1 234,56") == 1234.56)
    }
}



