//
//  BillSession+Sharing.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 20.12.2025.
//

import Foundation

extension BillSession {
    func shareEqualResult() -> String {
        guard !participants.isEmpty else {
            return "Нет участников для разделения счета"
        }
        
        let amountPerPerson = equalAmountPerPerson()
        
        let amounts: [UUID : Double] = participants.reduce(into: [:]) { dict, participant in
            dict[participant.id] = amountPerPerson
        }
        
        return ShareService.formatFullBill(
            totalAmount: billAmount,
            distributedAmount: totalAmount,
            participants: participants,
            participantAmount: amounts)
    }
    
    func shareItemizedResult() -> String {
        guard !participants.isEmpty else {
            return "Нет участников для разделения счета"
        }
        
        let distributedAmount = receiptItems
            .flatMap { billItem in
                billItem.units
                    .filter { !$0.payers.isEmpty }
                    .map { _ in billItem.pricePerUnit }
            }
            .reduce(0, +)
        
        let amounts: [UUID : Double] = participants.reduce(into: [:]) { dict, participant in
            let amount = receiptItems
                .flatMap { billItem in
                    billItem.units
                        .filter { $0.payers.contains(participant.id) }
                        .map { $0.splitAmount(price: billItem.pricePerUnit) }
                }
                .reduce(0, +)
            dict[participant.id] = amount
        }
        
        return ShareService.formatFullBill(
            totalAmount: totalAmount,
            distributedAmount: distributedAmount,
            participants: participants,
            participantAmount: amounts)
    }
    
    func shareCustomResult() -> String {
        guard !participants.isEmpty else {
            return "Нет участников для разделения счета"
        }
        
        let distributedAmount = customPaymentShares.reduce(0) { $0 + $1.amount }
        
        let amounts: [UUID : Double] = participants.reduce(into: [:]) { dict, participant in
            let amount = customPaymentShares
                .filter { $0.participantId == participant.id }
                .reduce(0) { $0 + $1.amount }
            dict[participant.id] = amount
        }
        
        return ShareService.formatFullBill(
            totalAmount: totalAmount,
            distributedAmount: distributedAmount,
            participants: participants,
            participantAmount: amounts)
    }
}
