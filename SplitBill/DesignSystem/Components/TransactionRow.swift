//
//  TransactionRow.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 23.12.2025.
//

import SwiftUI

struct TransactionRow: View {
    let paymentShare: PaymentShare
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(paymentShare.color.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Text(initials(for: paymentShare.name))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(paymentShare.color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(paymentShare.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("Оплачивает")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("\(paymentShare.amount, specifier: "%.2f ₽")")
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
