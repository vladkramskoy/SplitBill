//
//  Colors.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 09.12.2025.
//

import SwiftUI

extension Color {
    
    // MARK: - Color Initializer (Light/Dark)
    
    init(light: String, dark: String) {
        self.init(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(hex: dark)
            default:
                return UIColor(hex: light)
            }
        })
    }
    
    // MARK: Colors
    
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
        
        static let secondaryGradient = LinearGradient(
            colors: [.pink, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let validAmountGradient = LinearGradient(
            colors: [.green, .mint],
            startPoint: .leading, endPoint: .trailing
        )
        
        static let invalidAmounGtradient = LinearGradient(
            colors: [.red, .orange],
            startPoint: .leading, endPoint: .trailing
        )
        
        static let backgroundLight = Color.blue.opacity(0.1)
        static let backgroundLighter = Color.cyan.opacity(0.05)
        
        static let backgroundGradient = LinearGradient(
            colors: [backgroundLight, backgroundLighter],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // MARK: Participant Colors
        
        static let participantColors: [Color] = [
            adaptiveParticipant1,
            adaptiveParticipant2,
            adaptiveParticipant3,
            adaptiveParticipant4,
            adaptiveParticipant5,
            adaptiveParticipant6,
            adaptiveParticipant7,
            adaptiveParticipant8
        ]
        
        static var adaptiveParticipant1: Color {
            Color(light: "5C6BC0", dark: "7986CB") // Indigo
        }
        
        static var adaptiveParticipant2: Color {
            Color(light: "AB47BC", dark: "BA68C8") // Purple
        }
        
        static var adaptiveParticipant3: Color {
            Color(light: "EC407A", dark: "F06292") // Pink
        }
        
        static var adaptiveParticipant4: Color {
            Color(light: "FF7043", dark: "FF8A65") // Deep Orange
        }
        
        static var adaptiveParticipant5: Color {
            Color(light: "FFA726", dark: "FFB74D") // Orange
        }
        
        static var adaptiveParticipant6: Color {
            Color(light: "66BB6A", dark: "81C784") // Green
        }
        
        static var adaptiveParticipant7: Color {
            Color(light: "26A69A", dark: "4DB6AC") // Teal
        }
        
        static var adaptiveParticipant8: Color {
            Color(light: "42A5F5", dark: "64B5F6") // Blue
        }
        
        // MARK: Participant Color Methods
        
        static func participantColor(at index: Int) -> Color {
            participantColors[index % participantColors.count]
        }
    }
}

// MARK: Hex Color Initializer

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}
