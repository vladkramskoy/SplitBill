//
//  AddButton.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 10.12.2025.
//

import SwiftUI

struct AddButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: action) {
                HStack(spacing: 10) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22))
                    Text(title)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.SplitBill.primaryGradient.opacity(0.8))
                .clipShape(Capsule())
                .shadow(color: Color.blue.opacity(0.4), radius: 12, x: 0, y: 6)
            }
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    AddButton(title: "Добавить блюдо", action: {})
}
