//
//  ParticipantCell.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 23.12.2025.
//

import SwiftUI

struct ParticipantCell: View {
    let participant: Participant
    let amount: Double
    let onShare: (() -> String)
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(participant.color.opacity(0.15))
                .frame(width: 40, height: 40)
                .overlay {
                    Text(initials(for: participant.name))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(participant.color)
                }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(participant.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Text("\(amount.currencyFormatted)")
                    .font(.caption)
                    .foregroundStyle(amount > 0 ? participant.color : .secondary)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ShareLink(item: onShare()) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16))
                        .foregroundStyle(participant.color)
                        .frame(width: 24, height: 24)
                }
            }
        }
        .padding(12)
        .frame(height: 64)
        .background(participant.color.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(participant.color.opacity(0.2), lineWidth: 1)
        }
    }
    
    private func initials(for name: String) -> String {
        let names = name.split(separator: " ")
        let initials = names.prefix(2).map { String($0.first ?? Character("")) }
        return initials.joined()
    }
}

#Preview {
    let participant = Participant(name: "Даша", color: Color.SplitBill.adaptiveParticipant1)
    
    ParticipantCell(
        participant: participant,
        amount: 1000,
        onShare: { "" })
}
