//
//  CustomRemainsIllustration.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 27.12.2025.
//

import SwiftUI

struct CustomRemainsIllustration: View {
    @State private var animate = false
    @State private var progressAnimation: CGFloat = 0
    
    let gradient: [Color]
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("1250 ₽")
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
                                    colors: [.blue, .cyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ).opacity(0.6)
                            )
                            .frame(width: geometry.size.width * progressAnimation)
                    }
                }
                .frame(height: 8)
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Text("Распределить остаток")
                            .font(.caption)
                            .fontWeight(.light)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .light))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 8)
                    .background(Color.blue.opacity(0.1))
                    .foregroundStyle(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    HStack(spacing: 4) {}
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 8)
                    .background(Color.red.opacity(0.1))
                    .foregroundStyle(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            .scaleEffect(animate ? 1 : 0.9)
            .opacity(animate ? 1 : 0)
            
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Поровну между всеми")
                    Text("На участников без долей")
                }
                .padding(16)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                .scaleEffect(animate ? 1 : 0.9)
                .opacity(animate ? 1 : 0)
                
                Spacer()
            }
        }
        .padding(.horizontal, 40)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1)) {
                animate = true
            }
            withAnimation(.spring(response: 1.0, dampingFraction: 0.9).delay(0.3)) {
                progressAnimation = 0.5
            }
        }
    }
}

#Preview {
    CustomRemainsIllustration(gradient: [.orange, .red])
}
