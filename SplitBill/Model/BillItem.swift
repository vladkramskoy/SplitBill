//
//  BillItem.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 10.11.2025.
//

import Foundation

struct BillItem: Identifiable {
    let id: UUID
    let name: String
    var emoji = "🍽️"
    let quantity: Int
    let pricePerUnit: Double
    var units: [BillUnit]
    var totalPrice: Double { Double(quantity) * pricePerUnit }
}
