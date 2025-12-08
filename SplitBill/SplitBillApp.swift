//
//  SplitBillApp.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 21.05.2025.
//

import SwiftUI
import FirebaseCore
import FirebaseCrashlytics

@main
struct SplitBillApp: App {
    init() {
        FirebaseApp.configure()
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
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
