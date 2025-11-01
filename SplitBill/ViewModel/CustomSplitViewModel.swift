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
    
    func remainingAmount(total: Double, participants: [Participant]) -> Double {
        total - distributedAmount(from: participants)
    }
    
    func distributionProgress(total: Double, participants: [Participant]) -> Double {
        guard total > 0 else { return 0 }
        return distributedAmount(from: participants) / total
    }
}
