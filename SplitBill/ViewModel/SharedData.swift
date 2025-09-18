//
//  SharedData.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 22.05.2025.
//

import Foundation

final class SharedData: ObservableObject {
    
    @Published var participants: [Participant] = []
    @Published var billAmount = ""
    @Published var tipPercentage = 15.0
    @Published var tipAmount = ""
    @Published var isTipEnable = false
    
    let minParticipants = 2
    
    var totalBaseAmount: Int {
        participants.reduce(0) { $0 + $1.baseShares.reduce(0, +) }
    }
    
    var totalTipAmount: Int {
        var sum = 0
        for tips in participants {
            sum += tips.tipShares.reduce(0, +)
        }
        
        return sum
    }
    
    var totalAmount: Int {
        totalBaseAmount + totalTipAmount
    }
    
    var containsAmounts: Bool {
        participants.contains { !$0.baseShares.isEmpty }
    }
    
    init() {
        participants = (0..<minParticipants).map { _ in
            Participant()
        }
    }
    
    func resetToInitialState() {
        participants = (0..<minParticipants).map { _ in
            Participant()
        }
        
        tipPercentage = 15.0
        tipAmount = ""
        isTipEnable = false
    }
}
