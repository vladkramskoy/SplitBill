//
//  TipCalculationType.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 28.08.2025.
//

enum TipCalculationType: String, CaseIterable {
    case percentage = "Процент"
    case fixedAmount = "Фиксированная сумма"
    
    var id: String { self.rawValue }
}
