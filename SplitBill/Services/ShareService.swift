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
        let participantNames = participants.map { "\($0.name) — \(participantAmount[$0.id]?.currencyFormatted ?? "-")" }.joined(separator: "\n")
        
        let messageText = """
        📊 Разделить счёт
                        
        Общая сумма: \(totalAmount.currencyFormatted)
        Распределено: \(distributedAmount.currencyFormatted)
                        
        👥 Участники:
        \(participantNames)
                        
        ✅ Рассчитано с помощью приложения «Раздели счёт»
        
        ⬇️Скачать в AppStore:
        https://apps.apple.com/app/id6756733884
        """
        
        return messageText
    }
    
    static func formatForParticipant(participantName: String, participantAmount: Double, totalAmount: Double) -> String {
        
        let messageText = """
        📊 Разделить счёт
        
        Общая сумма: \(totalAmount.currencyFormatted)
        
        👥 Сумма для участника:
        \(participantName) — \(participantAmount.currencyFormatted)
        
        ✅ Рассчитано с помощью приложения «Раздели счёт»
                
        ⬇️Скачать в AppStore:
        https://apps.apple.com/app/id6756733884
        """
        
        return messageText
    }
}
