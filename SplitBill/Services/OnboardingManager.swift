//
//  OnboardingManager.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 27.12.2025.
//

import Foundation

final class OnboardingManager {
    private static let hasSeenOnboardingKey = "hasSeenWelcomeOnboarding"
    
    static var alwaysShowOnboarding: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    static var shouldShowOnboarding: Bool {
        if alwaysShowOnboarding {
            return true
        }
        return !UserDefaults.standard.bool(forKey: hasSeenOnboardingKey)
    }
    
    static func markOnboardingAsSeen() {
        UserDefaults.standard.set(true, forKey: hasSeenOnboardingKey)
    }
    
    static func resetOnboarding() {
        UserDefaults.standard.removeObject(forKey: hasSeenOnboardingKey)
    }
}
