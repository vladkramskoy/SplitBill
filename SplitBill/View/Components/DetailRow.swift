//
//  DetailRow.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 22.06.2025.
//

import SwiftUI

struct DetailRow: View {
    let title: String
    let value: Int
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text("\(value) ₽")
                .foregroundStyle(.primary)
        }
        .font(.subheadline)
    }
}

#Preview {
    DetailRow(title: "Чаевые", value: 50)
}
