//
//  SplitBillApp.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 21.05.2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics

@main
struct SplitBillApp: App {
    init() {
        FirebaseApp.configure()
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
        
        #if DEBUG
        Analytics.setAnalyticsCollectionEnabled(false)
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
        #else
        Analytics.setAnalyticsCollectionEnabled(true)
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        Crashlytics.crashlytics().setCustomValue("Release", forKey: "environment")
        #endif
        
        AnalyticsService.setup(appVersion: appVersion, buildNumber: buildNumber)
        
        let userID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
        Crashlytics.crashlytics().setUserID(userID)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
