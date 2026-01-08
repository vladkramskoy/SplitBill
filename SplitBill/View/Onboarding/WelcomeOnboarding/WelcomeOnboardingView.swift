//
//  WelcomeOnboardingView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 27.12.2025.
//

import SwiftUI

struct WelcomeOnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    
    private let steps: [WelcomeOnboardingStep] = [
        WelcomeOnboardingStep(
            title: "SplitBill",
            description: "Разделите счёт при любом сценарии.",
            icon: "chart.pie.fill",
            gradient: [.blue, .cyan],
            illustration: .intro
        ),
        WelcomeOnboardingStep(
            title: "Введите данные",
            description: "Укажите участников и сумму чека.",
            icon: "square.and.pencil",
            gradient: [.blue, .cyan],
            illustration: .features
        ),
        WelcomeOnboardingStep(
            title: "Выберите режим",
            description: "Точный ввод по блюдам или гибкое распределение по деньгам",
            icon: "rectangle.on.rectangle.badge.gearshape",
            gradient: [.blue, .cyan],
            illustration: .getStarted
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: steps[currentStep].gradient.map { $0.opacity(0.1) },
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 10)
                }
                
                TabView(selection: $currentStep) {
                    ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                        OnboardingStepView(
                            step: step,
                            illustrationContent: WelcomeIllustrationView(
                                type: step.illustration,
                                gradient: step.gradient,
                                isVisible: currentStep == index)
                        )
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                VStack(spacing: 20) {
                    PageIndicator(
                        currentPage: currentStep,
                        pageCount: steps.count,
                        activeColor: steps[currentStep].gradient[0]
                    )
                    .padding(.top, 20)
                    
                    Button {
                        handleNextTap()
                    } label: {
                        HStack(spacing: 10) {
                            Text(currentStep < steps.count - 1 ? "Далее" : "Понятно")
                                .fontWeight(.semibold)
                            
                            Image(systemName: currentStep < steps.count - 1 ? "arrow.right" : "checkmark")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: steps[currentStep].gradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: steps[currentStep].gradient[0].opacity(0.4), radius: 12, x: 0, y: 6
                        )
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 30)
                }
            }
        }
    }
    
    private func handleNextTap() {
        if currentStep < steps.count - 1 {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentStep += 1
            }
        } else {
            OnboardingManager.markOnboardingAsSeen()
            dismiss()
        }
    }
}

#Preview {
    WelcomeOnboardingView()
}
