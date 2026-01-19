//
//  BillSession.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 29.10.2025.
//

import Foundation

@Observable
final class BillSession {
    var participants: [Participant] = []
    var receiptItems: [BillItem] = []
    var customPaymentShares: [PaymentShare] = []
    var billAmount: Double = 0
    var tipAmount: Double = 0
    var totalAmount: Double = 0
    var sessionStartTime: Date?
    
    func startSession() {
        sessionStartTime = Date()
    }
    
    func reset() {
        participants = []
        receiptItems = []
        customPaymentShares = []
        billAmount = 0
        tipAmount = 0
        totalAmount = 0
        sessionStartTime = nil
    }
    
    func equalAmountPerPerson() -> Double {
        guard !participants.isEmpty else { return 0 }
        return totalAmount / Double(participants.count)
    }
    
    func getSessionDuration() -> Int? {
        guard let start = sessionStartTime else { return nil }
        return Int(Date().timeIntervalSince(start))
    }
}
