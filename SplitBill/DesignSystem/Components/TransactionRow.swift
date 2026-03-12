//
//  TransactionRow.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 23.12.2025.
//

import SwiftUI

struct TransactionRow: View {
    let paymentShare: PaymentShare
    @Environment(\.decimalFormatter) private var formatter
    
    var body: some View {
        HStack {
            Text("💳")
                .font(.system(size: 32))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(paymentShare.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("Платежная доля")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(formatter.format(paymentShare.amount))
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 8)
    }
    
    private func initials(for name: String) -> String {
        let names = name.split(separator: " ")
        let initials = names.prefix(2).map { String($0.first ?? Character("")) }
        return initials.joined()
    }
}

#Preview {
    VStack(spacing: 12) {
        let shares = [
            PaymentShare(
                participantId: UUID(),
                name: "Петр Сидоров",
                amount: 500,
                color: Color.SplitBill.adaptiveParticipant1),
            PaymentShare(
                participantId: UUID(),
                name: "Мария Петрова",
                amount: 750,
                color: Color.SplitBill.adaptiveParticipant2)
        ]
        
        TransactionRow(paymentShare: shares[0])
        TransactionRow(paymentShare: shares[1])
    }
}
