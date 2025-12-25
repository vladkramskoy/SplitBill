//
//  PageIndicator.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 24.12.2025.
//

import SwiftUI

struct PageIndicator: View {
    let currentPage: Int
    let pageCount: Int
    let activeColor: Color
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? activeColor : Color(.systemGray4))
                    .frame(width: index == currentPage ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
            }
        }
    }
}

#Preview {
    PageIndicator(currentPage: 0, pageCount: 1, activeColor: .pink)
}
