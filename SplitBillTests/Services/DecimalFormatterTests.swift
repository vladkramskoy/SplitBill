//
//  DecimalFormatterTests.swift
//  SplitBillTests
//
//  Created by Vlad Kramskoy on 16.03.2026.
//

import SwiftUI
import Testing
@testable import SplitBill

struct DecimalFormatterTests {
    
    let formatter = DecimalFormatter(
        currencyCode: "RUB",
        locale: Locale(identifier: "ru_RU")
    )
    
    let formatterUS = DecimalFormatter(
        currencyCode: "USD",
        locale: Locale(identifier: "en_US")
    )
    
    // MARK: - format() - Russian Locale
    
    @Test func formatWholeNumber() async throws {
        let result = formatter.format(1500)
        #expect(result == "1\u{00A0}500,00\u{00A0}₽")
    }
    
    @Test func formatFractionalNumber() async throws {
        let result = formatter.format(1500.5)
        #expect(result == "1\u{00A0}500,50\u{00A0}₽")
    }
    
    @Test func formatZero() async throws {
        let result = formatter.format(0)
        #expect(result == "0,00\u{00A0}₽")
    }
    
    @Test func formatLargeNumber() async throws {
        let result = formatter.format(1000000)
        #expect(result == "1\u{00A0}000\u{00A0}000,00\u{00A0}₽")
    }
    
    // MARK: - formatCompact() - Russian Locale
    
    @Test func formatCompactWholeNumber() async throws {
        let result = formatter.formatCompact(1500)
        #expect(result == "1\u{00A0}500\u{00A0}₽")
    }
    
    @Test func formatCompactFractionalNumber() async throws {
        let result = formatter.formatCompact(1500.55)
        #expect(result == "1\u{00A0}500,55\u{00A0}₽")
    }
    
    @Test func formatCompactSingleDecimalPlace() async throws {
        let result = formatter.formatCompact(1500.1)
        #expect(result == "1\u{00A0}500,1\u{00A0}₽")
    }
    
    @Test func formatCompactZero() async throws {
        let result = formatter.formatCompact(0)
        #expect(result == "0\u{00A0}₽")
    }
    
    @Test func formatCompactLargeNumber() async throws {
        let result = formatter.formatCompact(1000000)
        #expect(result == "1\u{00A0}000\u{00A0}000\u{00A0}₽")
    }
    
    // MARK: - parse() - Russian Locale
    
    @Test func parseSimpleNumber() async throws {
        let result = formatter.parse("1500")
        #expect(result == 1500.0)
    }
    
    @Test func parseNumberWithSpace() async throws {
        let result = formatter.parse("1\u{00A0}500")
        #expect(result == 1500.0)
    }
    
    @Test func parseNumberWithComma() async throws {
        let result = formatter.parse("1500,5")
        #expect(result == 1500.5)
    }
    
    @Test func parseNumberWithSpaceAndComma() async throws {
        let result = formatter.parse("1\u{00A0}500,55")
        #expect(result == 1500.55)
    }
    
    @Test func parseZero() async throws {
        let result = formatter.parse("0")
        #expect(result == 0.0)
    }
    
    @Test func parseInvalidString() async throws {
        let result = formatter.parse("abc")
        #expect(result == nil)
    }
    
    @Test func parseEmptyString() async throws {
        let result = formatter.parse("")
        #expect(result == nil)
    }
    
    @Test func parseNumberWithDot() async throws {
        let result = formatter.parse("1500.5")
        #expect(result == nil)
    }
    
    @Test func parseNegativeNumber() async throws {
        let result = formatter.parse("-100")
        #expect(result == nil)
    }
    
    @Test func parseLargeNumber() async throws {
        let result = formatter.parse("999999999")
        #expect(result == 999_999_999.0)
    }
    
    // MARK: - currencySymbol
    
    @Test func currencySymbolRUB() async throws {
        #expect(formatter.currencySymbol == "₽")
    }
    
    @Test func currencySymbolUSD() async throws {
        #expect(formatterUS.currencySymbol == "$")
    }
    
    // MARK: - format() - US Locale
    
    @Test func formatWholeNumber_US() async throws {
        let result = formatterUS.format(1500)
        #expect(result == "$1,500.00")
    }
    
    @Test func formatFractionalNumber_US() async throws {
        let result = formatterUS.format(1500.5)
        #expect(result == "$1,500.50")
    }
    
    // MARK: - formatCompact() - US Locale
    
    @Test func formatCompactWholeNumber_US() async throws {
        let result = formatterUS.formatCompact(1500)
        #expect(result == "$1,500")
    }
    
    // MARK: - parse() - US Locale
    
    @Test func parseNumberWithDot_US() async throws {
        let result = formatterUS.parse("1500.5")
        #expect(result == 1500.5)
    }
}
