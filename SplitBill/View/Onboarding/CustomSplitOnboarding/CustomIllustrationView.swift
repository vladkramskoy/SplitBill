//
//  CustomIllustrationView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 27.12.2025.
//

import SwiftUI

struct CustomIllustrationView: View {
    let type: CustomIllustrationType
    let gradient: [Color]
    let isVisible: Bool
    
    var body: some View {
        switch type {
        case .customIllustration1:
            CustomPaymentSharesIllustration(gradient: [.gray, .secondary])
        case .customIllustration2:
            CustomRemainsIllustration(gradient: [.orange, .red])
        case .customIllustration3:
            CustomSummaryIllustration(gradient: [.green, .mint], isVisible: isVisible)
        }
    }
}

#Preview {
    CustomIllustrationView(type: .customIllustration1, gradient: [.blue, .cyan], isVisible: true)
}
