//
//  ShareService.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 19.11.2025.
//

import Foundation

final class ShareService {
    private init() {}
    
    static func formatFullBill(
        totalAmount: Double,
        distributedAmount: Double,
        billAmount: Double,
        tipAmount: Double,
        participants: [Participant],
        participantAmount: [UUID: Double]
    ) -> String {
        let participantNames = participants.map { "\($0.name) — \(participantAmount[$0.id]?.currencyFormatted ?? "-")" }.joined(separator: "\n")
        
        let billBreakdown = tipAmount > 0 ? """
        Сумма счёта: \(billAmount.currencyFormatted)
        Чаевые: \(tipAmount.currencyFormatted)
        —————————————
        Итого: \(totalAmount.currencyFormatted)
        """ : """
        Общая сумма: \(totalAmount.currencyFormatted)
        """
        
        let messageText = """
        📊 Разделить счёт
        
        \(billBreakdown)
        Распределено: \(distributedAmount.currencyFormatted)
                        
        👥 Участники:
        \(participantNames)
                        
        ✅ Рассчитано с помощью приложения «Раздели счёт»
        
        ⬇️Скачать в AppStore:
        https://apps.apple.com/app/id6756733884
        """
        
        return messageText
    }
    
    static func formatForParticipant(
        participantName: String,
        participantAmount: Double,
        totalAmount: Double,
        billAmount: Double,
        tipAmount: Double
    ) -> String {
        
        let billBreakdown = tipAmount > 0 ? """
        Сумма счёта: \(billAmount.currencyFormatted)
        Чаевые: \(tipAmount.currencyFormatted)
        —————————————
        Итого: \(totalAmount.currencyFormatted)
        """ : """
        Общая сумма: \(totalAmount.currencyFormatted)
        """
        
        let messageText = """
        📊 Разделить счёт
        
        \(billBreakdown)
        
        👥 Сумма для участника:
        \(participantName) — \(participantAmount.currencyFormatted)
        
        ✅ Рассчитано с помощью приложения «Раздели счёт»
                
        ⬇️Скачать в AppStore:
        https://apps.apple.com/app/id6756733884
        """
        
        return messageText
    }
}
