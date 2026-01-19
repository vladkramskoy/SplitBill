//
//  WelcomeIllustrationView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 27.12.2025.
//

import SwiftUI

struct WelcomeIllustrationView: View {
    let type: WelcomeIllustrationType
    let gradient: [Color]
    let isVisible: Bool
    
    var body: some View {
        switch type {
        case .intro:
            WelcomeSplitBillIllustration()
        case .features:
            WelcomeParticipantsIllustration()
        case .getStarted:
            WelcomeSelectModeIllustration(isVisible: isVisible)
        }
    }
}

#Preview {
    WelcomeIllustrationView(type: .intro, gradient: [.blue, .cyan], isVisible: true)
}
