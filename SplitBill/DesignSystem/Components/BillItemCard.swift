//
//  BillItemCard.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 15.11.2025.
//

import SwiftUI

struct BillItemCard: View {
    private let formatter: DecimalFormatting
    @Binding var item: BillItem
    let participants: [Participant]
    let onSplitEqually: () -> Void
    let onReset: () -> Void
    let onDelete: () -> Void
    
    init(item: Binding<BillItem>,
         formatter: DecimalFormatting = DecimalFormatter(),
         participants: [Participant],
         onSplitEqually: @escaping () -> Void,
         onReset: @escaping () -> Void,
         onDelete: @escaping () -> Void) {
        self._item = item
        self.formatter = formatter
        self.participants = participants
        self.onSplitEqually = onSplitEqually
        self.onReset = onReset
        self.onDelete = onDelete
    }
    
    private var distributedUnits: Int {
        var value = 0
        
        for unit in item.units {
            if !unit.payers.isEmpty {
                value += 1
            }
        }
        return value
    }
    
    private var isFullyDistribuded: Bool {
        item.units.allSatisfy { !$0.payers.isEmpty }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text(item.emoji)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("\(formatter.format(item.pricePerUnit)) × \(item.quantity) шт.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(formatter.format(item.totalPrice)) ₽")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("\(distributedUnits)/\(item.units.count)")
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(isFullyDistribuded ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                        .foregroundStyle(isFullyDistribuded ? .green : .orange)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            
            Divider()
            
            ForEach(0..<item.units.count, id: \.self) { unitIndex in
                UnitDistibutionRow(item: $item,
                                   participants: participants,
                                   unitNumber: unitIndex + 1,
                                   unitIndex: unitIndex)
            }
            
            HStack {
                Button(action: onSplitEqually) {
                    HStack(spacing: 4) {
                        Image(systemName: "equal.circle")
                        Text("Поровну на всех")
                    }
                    .font(.caption)
                }
                
                Spacer()
                
                Button(action: onReset) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.clockwise")
                        Text("Сбросить")
                    }
                    .font(.caption)
                    .foregroundStyle(.orange)
                }
                
                Spacer()
                
                Button(role: .destructive, action: onDelete) {
                    HStack(spacing: 4) {
                        Image(systemName: "trash")
                        Text("Удалить")
                    }
                    .font(.caption)
                }
            }
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
            Participant(name: "Оля", color: Color.SplitBill.adaptiveParticipant1),
            Participant(name: "Маша", color: Color.SplitBill.adaptiveParticipant2),
            Participant(name: "Даша", color: Color.SplitBill.adaptiveParticipant3)
        ]
        
        var body: some View {
            BillItemCard(item: $item, participants: participants, onSplitEqually: {}, onReset: {}, onDelete: {})
        }
    }
    return PreviewWrapper()
}
