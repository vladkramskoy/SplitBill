//
//  ParticipantRow.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 03.10.2025.
//

import SwiftUI

struct ParticipantRow: View {
    let name: String
    let amount: Double
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Text(initials(for: name))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("Оплачивает")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("₽\(amount, specifier: "%.2f")")
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
    ParticipantRow(name: "Петр Сидоров", amount: 500)
    ParticipantRow(name: "Мария Петрова", amount: 750)
}
