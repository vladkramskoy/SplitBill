//
//  CustomSplitViewModel.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 22.10.2025.
//

import Foundation

final class CustomSplitViewModel: ObservableObject {
    @Published var amountPaymentInput = ""
    @Published var selectedPersonIndex = 0
    
    private let formatter: DecimalFormatting
    
    init(formatter: DecimalFormatting = DecimalFormatter()) {
        self.formatter = formatter
    }
    
    func addPaymentShare(to participants: inout [Participant]) {
        guard let share = formatter.parse(amountPaymentInput) else { return }
        
        if selectedPersonIndex < participants.count {
            participants[selectedPersonIndex].paymentShares.append(share)
        }
    }
    
    func distributedAmount(from participants: [Participant]) -> Double {
        participants.reduce(0) { $0 + $1.mustPayAll }
    }
    
    func distributeRemaining(total: Double, participants: inout [Participant]) {
        guard participants.count > 0 else { return }
        
        let remaining = remainingAmount(total: total, participants: participants)
        let share = remaining / Double(participants.count)
        
        for index in participants.indices {
            participants[index].paymentShares.append(share)
        }
    }
    
    func resetAll(from participants: inout [Participant]) {
        for index in participants.indices {
            participants[index].paymentShares = []
        }
    }
    
    func remainingAmount(total: Double, participants: [Participant]) -> Double {
        total - distributedAmount(from: participants)
    }
    
    func distributionProgress(total: Double, participants: [Participant]) -> Double {
        guard total > 0 else { return 0 }
        return distributedAmount(from: participants) / total
    }
}
