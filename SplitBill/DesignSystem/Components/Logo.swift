//
//  Logo.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 09.12.2025.
//

import SwiftUI

struct Logo: View {
    var body: some View {
        HStack(spacing: 4) {
            Text("Split")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(Color.SplitBill.primaryBlue)
            
            Text("Bill")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(Color.SplitBill.primaryBlue)
            
            Image(systemName: "receipt")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(Color.SplitBill.blueCyanGradient)
        }
        .shadow(color: .blue.opacity(0.2), radius: 8, y: 4)
    }
}

#Preview {
    Logo()
}
