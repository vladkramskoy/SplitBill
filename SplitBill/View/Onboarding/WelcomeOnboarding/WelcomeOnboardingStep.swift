//
//  WelcomeOnboardingStep.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 27.12.2025.
//

import SwiftUI

struct WelcomeOnboardingStep: OnboardingStep, Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let gradient: [Color]
    let illustration: WelcomeIllustrationType
}

enum WelcomeIllustrationType {
    case intro
    case features
    case getStarted
}
