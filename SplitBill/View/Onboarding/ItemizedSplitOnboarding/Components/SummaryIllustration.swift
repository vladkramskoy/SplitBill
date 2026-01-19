//
//  SummaryIllustration.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 24.12.2025.
//

import SwiftUI

struct SummaryIllustration: View {
    @State private var animate = false
    @State private var progressAnimation: CGFloat = 0
    @State private var hasAnimated = false
    
    let gradient: [Color]
    let isVisible: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("2500 ₽")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.secondary.opacity(0.4))
                            .frame(width: 60, height: 8)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 6) {
                        HStack(spacing: 4) {
                            Circle()
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: gradient,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .opacity(0.6)
                                .frame(width: 14, height: 12)
                            
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: gradient,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .opacity(0.6)
                                .frame(width: 40, height: 12)
                        }
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.secondary.opacity(0.4))
                            .frame(width: 50, height: 7)
                    }
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(.systemGray5))
                            .frame(height: 8)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.green, .mint],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ).opacity(0.6)
                            )
                            .frame(width: geometry.size.width * progressAnimation)
                    }
                }
                .frame(height: 8)
            }
            .padding(16)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            .scaleEffect(animate ? 1 : 0.9)
            .opacity(animate ? 1 : 0)
            
            VStack(spacing: 12) {
                ForEach(0..<3) { index in
                    HStack(spacing: 12) {
                        Circle()
                            .fill([Color.blue, Color.purple, Color.pink][index].opacity(0.2))
                            .frame(width: 40, height: 40)
                            .overlay {
                                Text(["О", "П", "М"][index])
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle([Color.blue, Color.purple, Color.pink][index])
                            }
                        
                        Text(["Олег", "Паша", "Маша"][index])
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text([850, 1200, 450][index].currencyFormatted)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(gradient[0])
                    }
                    .padding(12)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .scaleEffect(animate ? 1 : 0.8)
                    .opacity(animate ? 1 : 0)
                    .offset(x: animate ? 0 : -20)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.7)
                        .delay(0.3 + Double(index) * 0.1), value: animate
                    )
                }
            }
        }
        .padding(.horizontal, 40)
        .onChange(of: isVisible) { _, newValue in
            if newValue && !hasAnimated {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1)) {
                    animate = true
                }
                withAnimation(.spring(response: 1.0, dampingFraction: 0.9).delay(0.3)) {
                    progressAnimation = 1.0
                }
                
                hasAnimated = true
            }
        }
        .onAppear {
            if isVisible && !hasAnimated {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1)) {
                    animate = true
                }
                withAnimation(.spring(response: 1.0, dampingFraction: 0.9).delay(0.3)) {
                    progressAnimation = 1.0
                }
                
                hasAnimated = true
            }
        }
    }
}

#Preview {
    SummaryIllustration(gradient: [.green, .mint], isVisible: true)
}
