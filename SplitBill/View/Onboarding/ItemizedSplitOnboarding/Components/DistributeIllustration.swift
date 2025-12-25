//
//  DistributeIllustration.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 24.12.2025.
//

import SwiftUI

struct DistributeIllustration: View {
    let gradient: [Color]
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 12) {
                Text("🍕")
                    .font(.system(size: 36))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Пицца")
                        .font(.headline)
                    Text("500 ₽ × 2")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .padding(16)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
            
            VStack(spacing: 12) {
                ForEach(0..<2) { unitIndex in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(unitIndex + 1)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .frame(width: 24, height: 24)
                                .background(Circle().fill(gradient[0]))
                            
                            Text("500 ₽")
                                .font(.caption)
                            
                            Spacer()
                        }
                        
                        HStack(spacing: 8) {
                            ForEach(0..<2) { personIndex in
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill([Color.blue, Color.purple][personIndex])
                                        .frame(width: 20, height: 20)
                                    Text(["Олег", "Паша"][personIndex])
                                        .font(.caption)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill([Color.blue, Color.purple][personIndex].opacity(0.15))
                                )
                                .scaleEffect(animate ? 1 : 0.5)
                                .opacity(animate ? 1 : 0)
                                .animation(
                                    .spring(response: 0.6, dampingFraction: 0.6)
                                    .delay(Double(unitIndex * 2 + personIndex) * 0.15), value: animate
                                )
                            }
                        }
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(gradient[0].opacity(0.08))
                    )
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal, 40)
        .onAppear { animate = true }
    }
}

#Preview {
    DistributeIllustration(gradient: [.orange])
}
