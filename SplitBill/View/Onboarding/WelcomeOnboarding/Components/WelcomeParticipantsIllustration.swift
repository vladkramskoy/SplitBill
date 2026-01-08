//
//  WelcomeParticipantsIllustration.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 27.12.2025.
//

import SwiftUI

struct WelcomeParticipantsIllustration: View {
    @State private var animate = false
    @State private var animatedAmount:  Double = 0
    
    let colors = [Color.SplitBill.adaptiveParticipant1, Color.SplitBill.adaptiveParticipant2, Color.SplitBill.adaptiveParticipant3]
    
    var body: some View {
        VStack(spacing: 8) {
            VStack {
                Text("Участники")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.gray.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(0..<3) { index in
                    HStack {
                        Circle()
                            .fill(colors[index].opacity(0.6))
                            .frame(width: 40, height: 40)
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(.gray.opacity(0.5))
                            .frame(width: 120, height: 12)
                        
                        Spacer()
                        
                        Circle()
                            .fill(.red.opacity(0.8))
                            .frame(width: 15, height: 15)
                    }
                    .scaleEffect(animate ? 1 : 0.8)
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : 20)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.7)
                        .delay(Double(index) * 0.1), value: animate
                    )
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
            
            Image(systemName: "arrowshape.down.fill")
                .frame(width: 40, height: 40, alignment: .center)
                .foregroundStyle(.secondary.opacity(0.5))
              
            VStack {
                VStack {
                    Text("Сумма чека")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.gray.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                    
                    HStack() {
                        Spacer()
                        
                        Text("10000")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(.green.opacity(0.8))
                        
                        Spacer()
                        
                        Text("₽")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(.secondary.opacity(0.5))
                    }
                }
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
                .delay(3.0 * 0.1), value: animate
            )
        }
        .padding(.horizontal, 40)
        .onAppear { animate = true }
    }
}

#Preview {
    WelcomeParticipantsIllustration()
}
