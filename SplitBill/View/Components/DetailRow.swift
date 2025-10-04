//
//  DetailRow.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 22.06.2025.
//

import SwiftUI

struct DetailRow: View {
    let title: String
    let value: Double
    let isTotal: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(isTotal ? .primary : .secondary)
            
            Spacer()
            
            Text("₽\(value, specifier: "%.2f")")
                .fontWeight(isTotal ? .bold : .regular)
                .foregroundStyle(isTotal ? .blue : .secondary)
        }
        .font(isTotal ? .headline : .body)
    }
}

#Preview {
    DetailRow(title: "Чаевые", value: 50, isTotal: false)
    DetailRow(title: "Чаевые", value: 50, isTotal: true)
}
