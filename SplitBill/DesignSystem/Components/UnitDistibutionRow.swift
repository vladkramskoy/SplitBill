//
//  UnitDistibutionRow.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 15.11.2025.
//

import SwiftUI

struct UnitDistibutionRow: View {
    private let formatter: DecimalFormatting
    @Binding var item: BillItem
    let participants: [Participant]
    let unitNumber: Int
    let unitIndex: Int
    
    init(formatter: DecimalFormatting = DecimalFormatter(), item: Binding<BillItem>, participants: [Participant], unitNumber: Int, unitIndex: Int) {
        self.formatter = formatter
        self._item = item
        self.participants = participants
        self.unitNumber = unitNumber
        self.unitIndex = unitIndex
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(unitNumber)× \(item.name)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(formatter.format(item.pricePerUnit)) ₽")
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(participants) { participant in
                        personButton(for: participant)
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(item.units[unitIndex].payers.isEmpty ? Color(.systemGray6) : Color(.blue).opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(item.units[unitIndex].payers.isEmpty ? Color.clear : Color(.blue).opacity(0.2), lineWidth: 1)
        )
    }
    
    // MARK: Person Button
    
    private func personButton(for participant: Participant) -> some View {
        Button(action: {
            togglePersonSelection(participantID: participant.id)
        }) {
            VStack(spacing: 6) {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(item.units[unitIndex].payers.contains(participant.id) ? Color.blue : Color(.systemGray5))
                        .frame(width: 40, height: 40)
                        .overlay {
                            Text(String(participant.name.prefix(1)))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(item.units[unitIndex].payers.contains(participant.id) ? .white : .primary)
                        }
                    
                    if item.units[unitIndex].payers.contains(participant.id) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.white)
                            .background(Circle().fill(Color.green))
                            .font(.system(size: 14))
                            .offset(x: 4, y: 4)
                    }
                }
                
                Text(participant.name)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(item.units[unitIndex].payers.contains(participant.id) ? .blue : .secondary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
    }
    
    func togglePersonSelection(participantID: UUID) {
        if item.units[unitIndex].payers.contains(participantID) {
            item.units[unitIndex].payers.removeAll { $0 == participantID }
        } else {
            item.units[unitIndex].payers.append(participantID)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var item = BillItem(
            id: UUID(),
            name: "Вино красное",
            quantity: 2,
            pricePerUnit: 800,
            units: [
                BillUnit(id: UUID(), payers: []),
                BillUnit(id: UUID(), payers: [])
            ]
        )
        let participants = [
            Participant(name: "Оля"),
            Participant(name: "Маша"),
            Participant(name: "Даша")
        ]
        
        var body: some View {
            UnitDistibutionRow(
                item: $item,
                participants: participants,
                unitNumber: 1,
                unitIndex: 0
            )
        }
    }
    return PreviewWrapper()
}
