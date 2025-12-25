//
//  ItemsIllustration.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 24.12.2025.
//

import SwiftUI

struct ItemsIllustration: View {
    let gradient: [Color]
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<3) { index in
                HStack(spacing: 12) {
                    Text(["🍕", "🥗", "🍝"][index])
                        .font(.system(size: 40))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(gradient[0].opacity(0.3))
                            .frame(width: 120, height: 12)
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(gradient[1].opacity(0.2))
                            .frame(width: 80, height: 10)
                    }
                    
                    Spacer()
                    
                    Text("₽")
                        .font(.headline)
                        .foregroundStyle(gradient[0])
                }
                .padding(16)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                .scaleEffect(animate ? 1 : 0.8)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 20)
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.7)
                    .delay(Double(index) * 0.1), value: animate
                )
            }
        }
        .padding(.horizontal, 40)
        .onAppear { animate = true }
    }
}

#Preview {
    ItemsIllustration(gradient: [.blue, .cyan])
}
