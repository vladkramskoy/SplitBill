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
