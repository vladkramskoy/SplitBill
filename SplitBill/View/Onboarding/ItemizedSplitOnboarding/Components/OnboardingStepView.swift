//
//  OnboardingStepView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 25.12.2025.
//

import SwiftUI

struct OnboardingStepView: View {
    let step: ItemizedOnboardingStep
    let isVisible: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            OnboardingIllustrationView(
                type: step.illustration,
                gradient: step.gradient,
                isVisible: isVisible
            )
            .frame(height: 280)
            
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: step.icon)
                    .font(.system(size: 50))
                    .foregroundStyle(
                        LinearGradient(
                            colors: step.gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text(step.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                
                Text(step.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
}

#Preview {
    let step = ItemizedOnboardingStep(
        title: "Готово!",
        description: "Сумма для каждого участника рассчитана",
        icon: "checkmark.circle.fill",
        gradient: [.green],
        illustration: .viewResults)
    
    OnboardingStepView(step: step, isVisible: true)
}
