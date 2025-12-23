//
//  Payment.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 07.11.2025.
//

import SwiftUI

struct PaymentShare {
    let id = UUID()
    let participantId: UUID
    let name: String
    let amount: Double
    let color: Color
}
