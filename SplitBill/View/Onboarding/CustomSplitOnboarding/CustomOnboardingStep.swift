//
//  CustomOnboardingStep.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 27.12.2025.
//

import SwiftUI

struct CustomOnboardingStep: OnboardingStep, Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let gradient: [Color]
    let illustration: CustomIllustrationType
}

enum CustomIllustrationType {
    case customIllustration1
    case customIllustration2
    case customIllustration3
}
