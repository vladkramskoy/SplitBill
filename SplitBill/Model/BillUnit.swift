//
//  BillUnit.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 16.11.2025.
//

import Foundation

struct BillUnit {
    let id: UUID
    var payers: [UUID]
    
    func splitAmount(price: Double) -> Double {
        return price / Double(payers.count)
    }
}
