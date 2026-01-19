//
//  ParticipantRow.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 03.10.2025.
//

import SwiftUI

struct ParticipantRow: View {
    let participant: Participant
    let amount: Double
    let onShare: (() -> String)
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(participant.color.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Text(initials(for: participant.name))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(participant.color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(participant.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("Оплачивает")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("\(amount, specifier: "%.2f ₽")")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            ShareLink(item: onShare()) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(participant.color)
                }
            }
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
        ParticipantRow(
            participant: Participant(name: "Петр Сидоров", color: Color.SplitBill.adaptiveParticipant1),
            amount: 500,
            onShare: { "" })
        ParticipantRow(
            participant: Participant(name: "Мария Петрова", color: Color.SplitBill.adaptiveParticipant2),
            amount: 750,
            onShare: { "" })
    }
}
