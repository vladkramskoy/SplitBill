//
//  ItemizedOnboardingStep.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 24.12.2025.
//

import SwiftUI

struct ItemizedOnboardingStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let gradient: [Color]
    let illustration: ItemizedIllustrationType
}

enum ItemizedIllustrationType {
    case addItems
    case distributePortions
    case viewResults
}
