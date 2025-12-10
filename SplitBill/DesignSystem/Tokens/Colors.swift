//
//  Colors.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 09.12.2025.
//

import SwiftUI

extension Color {
    struct SplitBill {
        static let primaryBlue = Color.blue
        static let primaryCyan = Color.cyan
        
        static let primaryGradient = LinearGradient(
            colors: [primaryBlue, primaryCyan],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        static let primaryGradientVertical = LinearGradient(
            colors: [primaryBlue, primaryCyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let backgroundLight = Color.blue.opacity(0.1)
        static let backgroundLighter = Color.cyan.opacity(0.05)
        
        static let backgroundGradient = LinearGradient(
            colors: [backgroundLight, backgroundLighter],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
