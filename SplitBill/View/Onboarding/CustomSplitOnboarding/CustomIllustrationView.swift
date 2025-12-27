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
            CustomIllustration1()
        case .customIllustration2:
            CustomIllustration2()
        case .customIllustration3:
            CustomIllustration3()
        }
    }
}

#Preview {
    CustomIllustrationView(type: .customIllustration1, gradient: [.blue, .cyan], isVisible: true)
}
