//
//  ItemizedSplitOnboardingView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 25.12.2025.
//

import SwiftUI

struct ItemizedSplitOnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    
    private let steps: [ItemizedOnboardingStep] = [
        ItemizedOnboardingStep(
            title: "Добавьте блюда",
            description: "Создайте список всех блюд из чека. Укажите название, цену и количество порций.",
            icon: "plus.circle.fill",
            gradient: [.blue, .cyan],
            illustration: .addItems
        ),
        ItemizedOnboardingStep(
            title: "Распределите порции",
            description: "Укажите кто что ел. Можно делить одну порцию на несколько человек!",
            icon: "chart.pie.fill",
            gradient: [.orange, .red],
            illustration: .distributePortions
        ),
        ItemizedOnboardingStep(
            title: "Готово!",
            description: "Сумма для каждого рассчитается автоматически. Просто и справедливо.",
            icon: "checkmark.circle.fill",
            gradient: [.green, .mint],
            illustration: .viewResults
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
                            illustrationContent: ItemizedIllustrationView(
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
            dismiss()
        }
    }
}

#Preview {
    ItemizedSplitOnboardingView()
}
