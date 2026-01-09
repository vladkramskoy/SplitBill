//
//  WelcomeSelectModeIllustration.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 27.12.2025.
//

import SwiftUI

struct WelcomeSelectModeIllustration: View {
    @State private var animate = false
    @State private var hasAnimated = false
    
    let isVisible: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 8) {
                AnimatedIconView(
                    icon: "fork.knife",
                    color: .orange,
                    size: .custom(outer: 60, inner: 48, icon: 24),
                    animationSpeed: .normal
                )
                
                VStack(spacing: 8) {
                    Text("По блюдам")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                .scaleEffect(animate ? 1 : 0.8)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 20)
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.7)
                    .delay(1.0 * 0.1), value: animate
                )
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color(.systemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
            
            HStack(spacing: 8) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                
                Text("или")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
            }
            
            VStack(spacing: 8) {
                AnimatedIconView(
                    icon: "banknote",
                    color: .green,
                    size: .custom(outer: 60, inner: 48, icon: 24),
                    animationSpeed: .normal
                )
                
                VStack(spacing: 8) {
                    Text("По договорённости")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                .scaleEffect(animate ? 1 : 0.8)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 20)
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.7)
                    .delay(2.0 * 0.1), value: animate
                )
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color(.systemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal, 80)
        .onChange(of: isVisible) { _, newValue in
            if newValue && !hasAnimated {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1)) {
                    animate = true
                }
                
                hasAnimated = true
            }
        }
        .onAppear {
            if isVisible && !hasAnimated {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1)) {
                    animate = true
                }
                
                hasAnimated = true
            }
        }

    }
}

#Preview {
    WelcomeSelectModeIllustration(isVisible: true)
}
