//
//  ShareService.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 19.11.2025.
//

import Foundation

final class ShareService {
    private init() {}
    
    static func formatFullBill(totalAmount: Double, distributedAmount: Double, participants: [Participant], participantAmount: [UUID: Double]) -> String {
        let participantNames = participants.map { "\($0.name) - \(participantAmount[$0.id]?.currencyFormatted ?? "-")" }.joined(separator: "\n")
        
        let messageText = "📊 Разделение счета\n\nОбщая сумма: \(totalAmount.currencyFormatted)\nРаспределено: \(distributedAmount.currencyFormatted)\n\n👥 Участники:\n\(participantNames)\n\nСоздано в SplitBill"
        
        return messageText
    }
    
    static func formatForParticipant(participantName: String, participantAmount: Double, totalAmount: Double) -> String {
        let messageText = "Привет, \(participantName)! 👋\n\nТвоя часть за счет: \(participantAmount.currencyFormatted)\n\nОбщая сумма была: \(totalAmount.currencyFormatted)"
        
        return messageText
    }
}
