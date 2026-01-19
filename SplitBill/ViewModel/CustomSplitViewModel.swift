//
//  CustomSplitViewModel.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 22.10.2025.
//

import Foundation

final class CustomSplitViewModel: ObservableObject {
    @Published var amountPaymentInput = ""
    @Published var selectedPersonIndices: [Int] = []
    @Published var validationError: String? = nil
    
    private let formatter: DecimalFormatting
    
    init(formatter: DecimalFormatting = DecimalFormatter()) {
        self.formatter = formatter
    }
    
    func addPaymentShare(to paymentShares: inout [PaymentShare], for participants: [Participant]) -> Bool {
        guard let amount = formatter.parse(amountPaymentInput), !selectedPersonIndices.isEmpty else {
            validationError = "Укажите сумму и участников"
            return false
        }
        
        let amountValidation = ValidationService.validatePaymentShareAmount(amount)
        guard amountValidation.isValid else {
            validationError = amountValidation.errorMessage
            return false
        }
        
        let tempShares = selectedPersonIndices.map { _ in
            PaymentShare(participantId: UUID(), name: "", amount: 0, color: .clear)
        }
        let sharesValidation = ValidationService.validatePaymentShares(paymentShares + tempShares)
        guard sharesValidation.isValid else {
            validationError = sharesValidation.errorMessage
            return false
        }
        
        let shareAmount = amount / Double(selectedPersonIndices.count)
        
        for index in selectedPersonIndices {
            guard index < participants.count else { continue }
            
            let participant = participants[index]
            let newPaymentShare = PaymentShare(
                participantId: participant.id,
                name: participant.name,
                amount: shareAmount,
                color: participant.color
            )
            paymentShares.append(newPaymentShare)
        }
        
        validationError = nil
        AnalyticsService.logPaymentShareAdded(totalShares: paymentShares.count)
        return true
    }
    
    func distributedAmount(from paymentShares: [PaymentShare]) -> Double {
        paymentShares.reduce(0) { $0 + $1.amount }
    }
    
    func distributeRemaining(total: Double, participants: [Participant], paymentShares: inout [PaymentShare]) {
        guard participants.count > 0 else { return }
        
        let remaining = remainingAmount(total: total, paymentShares: paymentShares)
        
        guard remaining > 0.01 else { return }
        
        let share = remaining / Double(participants.count)
        
        for participant in participants {
            let paymentShare = PaymentShare(
                participantId: participant.id,
                name: participant.name,
                amount: share,
                color: participant.color
            )
            paymentShares.append(paymentShare)
        }
    }
    
    func resetAll(from paymentShares: inout [PaymentShare]) {
        paymentShares = []
        
        AnalyticsService.logPaymentSharesReset(totalShares: paymentShares.count)
    }
    
    func distributeRemainingToUnassigned(total: Double, participants: [Participant], paymentShares: inout [PaymentShare]) {
        let assignedParticipantsIds = Set(paymentShares.map { $0.participantId })
        let unassignedParticipants = participants.filter { !assignedParticipantsIds.contains($0.id) }
        
        guard !unassignedParticipants.isEmpty else { return }
        
        let remaining = remainingAmount(total: total, paymentShares: paymentShares)
        
        guard remaining > 0.01 else { return }
        
        let share = remaining / Double(unassignedParticipants.count)
        
        for participant in unassignedParticipants {
            let paymentShare = PaymentShare(
                participantId: participant.id,
                name: participant.name,
                amount: share,
                color: participant.color
            )
            paymentShares.append(paymentShare)
        }
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
    
    func togglePersonSelection(at index: Int) {
        if selectedPersonIndices.contains(index) {
            selectedPersonIndices.removeAll { $0 == index }
        } else {
            selectedPersonIndices.append(index)
        }
    }
}
