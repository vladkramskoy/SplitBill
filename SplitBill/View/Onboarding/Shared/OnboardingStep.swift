//
//  OnboardingStep.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 27.12.2025.
//

import SwiftUI

protocol OnboardingStep {
    var title: String { get }
    var description: String { get }
    var icon: String { get }
    var gradient: [Color] { get }
}
