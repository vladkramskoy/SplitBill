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
    
    func addPaymentShare(to paymentShares: inout [PaymentShare], for participants: [Participant]) {
        guard let amount = formatter.parse(amountPaymentInput) else { return }
        
        if selectedPersonIndex < participants.count {
            let participantId = participants[selectedPersonIndex].id
            let newPaymentShare = PaymentShare(participantId: participantId, amount: amount)
            paymentShares.append(newPaymentShare)
        }
    }
    
    func distributedAmount(from paymentShares: [PaymentShare]) -> Double {
        paymentShares.reduce(0) { $0 + $1.amount }
    }
    
    func distributeRemaining(total: Double, participants: [Participant], paymentShares: inout [PaymentShare]) {
        guard participants.count > 0 else { return }
        
        let remaining = remainingAmount(total: total, paymentShares: paymentShares)
        let share = remaining / Double(participants.count)
        
        for participant in participants {
            let paymentShare = PaymentShare(participantId: participant.id, amount: share)
            paymentShares.append(paymentShare)
        }
    }
    
    func resetAll(from paymentShares: inout [PaymentShare]) {
        paymentShares = []
    }
    
    func remainingAmount(total: Double, paymentShares: [PaymentShare]) -> Double {
        total - distributedAmount(from: paymentShares)
    }
    
    func distributionProgress(total: Double, paymentShares: [PaymentShare]) -> Double {
        guard total > 0 else { return 0 }
        return distributedAmount(from: paymentShares) / total
    }
    
    func amountFor(participantId: UUID, paymentShares: [PaymentShare]) -> Double {
        paymentShares
            .filter { $0.participantId == participantId }
            .reduce(0) { $0 + $1.amount }
    }
}
