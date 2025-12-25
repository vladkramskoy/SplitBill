//
//  NextButton.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 10.12.2025.
//

import SwiftUI

struct NextButton: View {
    let title: String
    let action: () -> Void
    let isActive: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: action) {
                HStack(spacing: 10) {
                    Text(title)
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 22))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.SplitBill.blueCyanGradient)
                .clipShape(Capsule())
                .shadow(color: isActive ? Color.blue.opacity(0.4) : Color.clear,
                        radius: 12, x: 0, y: 6
                )
            }
            .disabled(!isActive)
            .opacity(isActive ? 1.0 : 0.5)
            .padding(.horizontal)
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    NextButton(title: "Начать разделение", action: {}, isActive: true)
}
