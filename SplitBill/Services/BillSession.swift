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
    var billAmount: Double = 0
    var tipAmount: Double = 0
    var totalAmount: Double = 0
    
    func reset() {
        participants = []
        billAmount = 0
        tipAmount = 0
        totalAmount = 0
    }
    
    func amountPerPerson() -> Double {
        guard !participants.isEmpty else { return 0 }
        return totalAmount / Double(participants.count)
    }
}
