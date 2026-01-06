//
//  SimpleParticipantRow.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 06.01.2026.
//

import SwiftUI

struct SimpleParticipantRow: View {
    let participant: Participant
    var onDelete: (() -> Void)? = nil
    
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
            
            Text(participant.name)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            if let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle")
                        .foregroundStyle(Color.red.opacity(0.7))
                        .buttonStyle(.plain)
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
        SimpleParticipantRow(
            participant: Participant(name: "Петр Сидоров", color: Color.SplitBill.adaptiveParticipant1),
            onDelete: {}
        )
        SimpleParticipantRow(
            participant: Participant(name: "Мария Петрова", color: Color.SplitBill.adaptiveParticipant2),
            onDelete: {}
        )
    }
}
