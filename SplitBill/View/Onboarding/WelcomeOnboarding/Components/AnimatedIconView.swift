//
//  AnimatedIconView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 07.01.2026.
//

import SwiftUI

struct AnimatedIconView: View {
    let icon: String
    let color: Color
    let size: AnimatedIconSize
    let aminationSpeed: AnimationSpeed
    
    @State private var isAnimating = false
    
    init(
        icon: String,
        color: Color,
        size: AnimatedIconSize = .medium,
        animationSpeed: AnimationSpeed = .normal
    ) {
        self.icon = icon
        self.color = color
        self.size = size
        self.aminationSpeed = animationSpeed
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: size.outerCircleSize, height: size.outerCircleSize)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(
                    .easeInOut(duration: aminationSpeed.circleDuration)
                    .repeatForever(autoreverses: true),
                    value: isAnimating)
            
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: size.innerCircleSize, height: size.innerCircleSize)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(
                    .easeInOut(duration: aminationSpeed.circleDuration)
                    .repeatForever(autoreverses: true),
                    value: isAnimating)
            
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [color, color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .rotationEffect(.degrees(isAnimating ? 5 : -5))
                .animation(
                    .easeInOut(duration: aminationSpeed.iconDuration)
                    .repeatForever(autoreverses: true),
                    value: isAnimating)
        }
        .frame(width: size.outerCircleSize, height: size.outerCircleSize)
        .onAppear {
            isAnimating = true
        }
    }
}

extension AnimatedIconView {
    enum AnimatedIconSize {
        case small
        case medium
        case large
        case custom(outer: CGFloat, inner: CGFloat, icon: CGFloat)
        
        var outerCircleSize: CGFloat {
            switch self {
            case .small: return 120
            case .medium: return 200
            case .large: return 280
            case .custom(let outher, _, _): return outher
            }
        }
        
        var innerCircleSize: CGFloat {
            switch self {
            case .small: return 96
            case .medium: return 160
            case .large: return 224
            case .custom(_, let inner, _): return inner
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 48
            case .medium: return 80
            case .large: return 112
            case .custom(_, _, let icon): return icon
            }
        }
    }
}

extension AnimatedIconView {
    enum AnimationSpeed {
        case slow
        case normal
        case fast
        case custom(circle: Double, icon: Double)
        
        var circleDuration: Double {
            switch self {
            case .slow: return 3.0
            case .normal: return 2.0
            case .fast: return 1.0
            case .custom(let circle, _): return circle
            }
        }
        
        var iconDuration: Double {
            switch self {
            case .slow: return 2.25
            case .normal: return 1.5
            case .fast: return 0.75
            case .custom(_, let icon): return icon
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        AnimatedIconView(
            icon: "chart.pie.fill",
            color: .purple,
            size: .small
        )
        
        AnimatedIconView(
            icon: "chart.pie.fill",
            color: .orange,
            size: .medium,
            animationSpeed: .slow
        )
        
        AnimatedIconView(
            icon: "receipt",
            color: .blue,
            size: .large,
            animationSpeed: .fast
        )
        
        AnimatedIconView(
            icon: "chart.pie.fill",
            color: .green,
            size: .custom(outer: 150, inner: 120, icon: 60)
        )
    }
}
