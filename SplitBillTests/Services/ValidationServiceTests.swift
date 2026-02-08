//
//  ValidationServiceTests.swift
//  SplitBillTests
//
//  Created by Vlad Kramskoy on 08.02.2026.
//

import SwiftUI
import Testing
@testable import SplitBill

struct ValidationServiceTests {
    
    // MARK: Tips
    
    @Test func validateTipAmountValidValue() async throws {
        let result = ValidationService.validateTipAmount(5000)
        #expect(result.isValid == true)
    }
    
    @Test func validateTipAmountMaxBoundary() async throws {
        let result = ValidationService.validateTipAmount(999_999.99)
        #expect(result.isValid == true)
    }
    
    @Test func validateTipAmountExceedsLimit() async throws {
        let result = ValidationService.validateTipAmount(1_000_000)
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Максимальная сумма: 999,999.99 ₽")
    }
    
    // MARK: Amount
    
    @Test func validateAmountValidValue() async throws {
        let result = ValidationService.validateAmount(1000)
        #expect(result.isValid == true)
    }
    
    @Test func validateAmountMinBoundary() async throws {
        let result = ValidationService.validateAmount(10)
        #expect(result.isValid == true)
    }
    
    @Test func validateAmountBelowMin() async throws {
        let result = ValidationService.validateAmount(9.99)
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Минимальная сумма: 10 ₽")
    }
    
    @Test func validateAmountMaxBoundary() async throws {
        let result = ValidationService.validateAmount(999_999.99)
        #expect(result.isValid == true)
    }
    
    @Test func validateAmountExceedsLimit() async throws {
        let result = ValidationService.validateAmount(1_000_000)
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Максимальная сумма: 999,999.99 ₽")
    }
    
    // MARK: Participants
    
    @Test func validateParticipantsEmpty() async throws {
        let participants: [Participant] = []
        
        let result = ValidationService.validateParticipants(participants)
        #expect(result.isValid == true)
    }
    
    @Test func validateParticipantsOneItem() async throws {
        let participants = [Participant(name: "Vlad", color: Color.SplitBill.adaptiveParticipant1)]
        
        let result = ValidationService.validateParticipants(participants)
        #expect(result.isValid == true)
    }
    
    @Test func validateParticipantsMaxBoundary() async throws {
        let participants = (1...20).map { i in
            Participant(name: "User\(i)", color: Color.SplitBill.adaptiveParticipant1)
        }
        
        let result = ValidationService.validateParticipants(participants)
        #expect(result.isValid == true)
    }
    
    @Test func validateParticipantsExceedsLimit() async throws {
        let participants = (1...21).map { i in
            Participant(name: "User\(i)", color: Color.SplitBill.adaptiveParticipant1)
        }
        
        let result = ValidationService.validateParticipants(participants)
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Максимум 20 участников")
    }
    
    // MARK: Participant Name
    
    @Test func validateParticipantNameValidValue() async throws {
        let name = "Vlad"
        
        let result = ValidationService.validateParticipantName(name)
        #expect(result.isValid == true)
    }
    
    @Test func validateParticipantNameEmpty() async throws {
        let name = ""
        
        let result = ValidationService.validateParticipantName(name)
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Имя не может быть пустым")
    }
    
    @Test func validateParticipantNameOnlyWhitespace() async throws {
        let name = " "
        
        let result = ValidationService.validateParticipantName(name)
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Имя не может быть пустым")
    }
    
    @Test func validateParticipantNameMaxBoundary() async throws {
        let name = String(repeating: "a", count: 30)
        
        let result = ValidationService.validateParticipantName(name)
        #expect(result.isValid == true)
    }
    
    @Test func validateParticipantNameExceedsLimit() async throws {
        let name = String(repeating: "a", count: 31)
        
        let result = ValidationService.validateParticipantName(name)
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Максимум 30 символов")
    }
    
    // MARK: Dish Name
    
    @Test func validateDishNameValidValue() async throws {
        let name = "Pizza"
        
        let result = ValidationService.validateDishName(name)
        #expect(result.isValid == true)
    }
    
    @Test func validateDishNameEmpty() async throws {
        let name = ""
        
        let result = ValidationService.validateDishName(name)
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Название не может быть пустым")
    }
    
    @Test func validateDishNameOnlyWhitespace() async throws {
        let name = " "
        
        let result = ValidationService.validateDishName(name)
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Название не может быть пустым")
    }
    
    @Test func validateDishNameMaxBoundary() async throws {
        let name = String(repeating: "a", count: 50)
        
        let result = ValidationService.validateDishName(name)
        #expect(result.isValid == true)
    }
    
    @Test func validateDishNameExceedsLimit() async throws {
        let name = String(repeating: "a", count: 51)
        
        let result = ValidationService.validateDishName(name)
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Максимум 50 символов")
    }
    
    // MARK: Dish Amount
    
    @Test func validateDishAmountValidValue() async throws {
        let result = ValidationService.validateDishAmount(5000)
        #expect(result.isValid == true)
    }
    
    @Test func validateDishAmountMaxBoundary() async throws {
        let result = ValidationService.validateDishAmount(99999.99)
        #expect(result.isValid == true)
    }
    
    @Test func validateDishAmountExceedsLimit() async throws {
        let result = ValidationService.validateDishAmount(100000)
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Максимальная сумма: 99999.99 ₽")
    }
    
    // MARK: Payment Share Amount
    
    @Test func validatePaymentShareAmountValidValue() async throws {
        let result = ValidationService.validatePaymentShareAmount(5000)
        #expect(result.isValid == true)
    }
    
    @Test func validatePaymentShareAmountMaxBoundary() async throws {
        let result = ValidationService.validatePaymentShareAmount(99999.99)
        #expect(result.isValid == true)
    }
    
    @Test func validatePaymentShareAmountExceedsLimit() async throws {
        let result = ValidationService.validatePaymentShareAmount(100000)
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Максимальная сумма: 99999.99 ₽")
    }
    
    // MARK: Receipt Items
    
    @Test func validateReceiptItemsEmpty() async throws {
        let receiptItems: [BillItem] = []
        let result = ValidationService.validateReceiptItems(receiptItems)
        #expect(result.isValid == true)
    }
    
    @Test func validateReceiptItemsValidValue() async throws {
        let receiptItems: [BillItem] = (1...10).map { i in
            let billItem = BillItem(id: UUID(), name: "Pizza\(i)", quantity: 5, pricePerUnit: 750, units: [])
            return billItem
        }
        
        let result = ValidationService.validateReceiptItems(receiptItems)
        #expect(result.isValid == true)
    }
    
    @Test func validateReceiptItemsMaxBoundary() async throws {
        let receiptItems: [BillItem] = (1...50).map { i in
            let billItem = BillItem(id: UUID(), name: "Pizza\(i)", quantity: 1, pricePerUnit: 750, units: [])
            return billItem
        }
        
        let result = ValidationService.validateReceiptItems(receiptItems)
        #expect(result.isValid == true)
    }
    
    @Test func validateReceiptItemsExceedsLimitItems() async throws {
        let receiptItems: [BillItem] = (1...51).map { i in
            let billItem = BillItem(id: UUID(), name: "Pizza\(i)", quantity: 1, pricePerUnit: 750, units: [])
            return billItem
        }
        
        let result = ValidationService.validateReceiptItems(receiptItems)
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Максимум 50 позиций в чеке")
    }
    
    @Test func validateReceiptItemsExceedsLimitQuantity() async throws {
        var receiptItems: [BillItem] = []
        let billItem = BillItem(id: UUID(), name: "Pizza", quantity: 100, pricePerUnit: 750, units: [])
        
        receiptItems.append(billItem)
        
        let result = ValidationService.validateReceiptItems(receiptItems)
        #expect(result.isValid == false)
        #expect(result.errorMessage?.contains("Pizza") == true)
    }
    
    // MARK: Payment Shares
    
    @Test func validatePaymentSharesEmpty() async throws {
        let shares: [PaymentShare] = []
        let result = ValidationService.validatePaymentShares(shares)
        #expect(result.isValid == true)
    }
    
    @Test func validatePaymentSharesMaxBoundary() async throws {
        let shares = (1...100).map { i in
            PaymentShare(participantId: UUID(), name: "User\(i)", amount: 100, color: .clear)
        }
        
        let result = ValidationService.validatePaymentShares(shares)
        #expect(result.isValid == true)
    }
    
    @Test func validatePaymentSharesExceedsLimit() async throws {
        let shares = (1...101).map { i in
            PaymentShare(participantId: UUID(), name: "User\(i)", amount: 100, color: .clear)
        }
        
        let result = ValidationService.validatePaymentShares(shares)
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Максимум 100 платежных долей")
    }
}
