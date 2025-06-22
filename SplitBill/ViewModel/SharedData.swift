//
//  SharedData.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 22.05.2025.
//

import Foundation

final class SharedData: ObservableObject {
    
    @Published var participants: [Participant]
    @Published var tipPercentage: Double = 10
    
    let minParticipants = 2
    let maxParticipants = 8
    
    var totalBaseAmount: Int {
        participants.reduce(0) { $0 + $1.baseShares.reduce(0, +) }
    }
    
    var totalTipAmount: Int {
        guard tipPercentage > 0 else { return 0 }
        return Int(ceil(Double(totalBaseAmount) * Double(tipPercentage) / 100.0))
    }
    
    var totalAmount: Int {
        totalBaseAmount + totalTipAmount
    }
    
    var containsAmounts: Bool {
        participants.contains { !$0.baseShares.isEmpty }
    }
    
    init() {
        self.participants = (0..<minParticipants).map { _ in
            Participant()
        }
    }
    
    func addParticipant() {
        guard participants.count < maxParticipants else { return }
        participants.append(Participant())
    }
    
    func removeParticipant() {
        guard participants.count > minParticipants else { return }
        participants.removeLast()
    }
    
    func resetToInitialState() {
        participants = (0..<minParticipants).map { _ in
            Participant()
        }
        tipPercentage = 10
    }
}
