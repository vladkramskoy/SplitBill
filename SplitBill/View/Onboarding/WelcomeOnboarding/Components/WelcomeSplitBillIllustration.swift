//
//  WelcomeSplitBillIllustration.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 27.12.2025.
//

import SwiftUI

struct WelcomeSplitBillIllustration: View {
    var body: some View {
        ZStack {
            AnimatedIconView(
                icon: "receipt",
                color: .blue,
                size: .large,
                animationSpeed: .fast
            )
            .offset(y: -30)

            HStack(spacing: 0) {
                AnimatedIconView(
                    icon: "person.3.fill",
                    color: .purple,
                    size: .small
                )
                Spacer()
                AnimatedIconView(
                    icon: "checkmark.circle.fill",
                    color: .green,
                    size: .small,
                    animationSpeed: .slow
                )
            }
            .padding(.horizontal, 24)
            .offset(y: 120)
        }
        .frame(height: 180)
        .padding()
    }
}

#Preview {
    WelcomeSplitBillIllustration()
}
