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
        participantAmount: [UUID: Double],
        formatter: DecimalFormatting
    ) -> String {
        let participantNames = participants.map { "\($0.name) — \(participantAmount[$0.id].map { formatter.formatCompact($0) } ?? "-")" }.joined(separator: "\n")
        
        let billBreakdown = tipAmount > 0 ? """
        Сумма счёта: \(formatter.formatCompact(billAmount))
        Чаевые: \(formatter.formatCompact(tipAmount))
        —————————————
        Итого: \(formatter.formatCompact(totalAmount))
        """ : """
        Общая сумма: \(formatter.formatCompact(totalAmount))
        """
        
        let messageText = """
        📊 Разделить счёт
        
        \(billBreakdown)
        Распределено: \(formatter.formatCompact(distributedAmount))
                        
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
        tipAmount: Double,
        formatter: DecimalFormatting
    ) -> String {
        
        let billBreakdown = tipAmount > 0 ? """
        Сумма счёта: \(formatter.formatCompact(billAmount))
        Чаевые: \(formatter.formatCompact(tipAmount))
        —————————————
        Итого: \(formatter.formatCompact(totalAmount))
        """ : """
        Общая сумма: \(formatter.formatCompact(totalAmount))
        """
        
        let messageText = """
        📊 Разделить счёт
        
        \(billBreakdown)
        
        👥 Сумма для участника:
        \(participantName) — \(formatter.formatCompact(participantAmount))
        
        ✅ Рассчитано с помощью приложения «Раздели счёт»
                
        ⬇️Скачать в AppStore:
        https://apps.apple.com/app/id6756733884
        """
        
        return messageText
    }
}
