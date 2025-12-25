//
//  OnboardingIllustrationView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 25.12.2025.
//

import SwiftUI

struct OnboardingIllustrationView: View {
    let type: ItemizedIllustrationType
    let gradient: [Color]
    let isVisible: Bool
    
    var body: some View {
        switch type {
        case .addItems:
            ItemsIllustration(gradient: gradient)
        case .distributePortions:
            DistributeIllustration(gradient: gradient)
        case .viewResults:
            SummaryIllustration(gradient: gradient, isVisible: isVisible)
        }
    }
}

#Preview {
    OnboardingIllustrationView(type: .addItems, gradient: [.blue, .cyan], isVisible: true)
}
