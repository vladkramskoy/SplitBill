//
//  AnalyticsService.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 05.12.2025.
//

import Foundation
import FirebaseAnalytics
import FirebaseCrashlytics

enum SplitMethod: String {
    case equal, itemized, custom
}

enum ShareType: String {
    case fullBill, participant
}

enum AnalyticsService {
    static func setup(appVersion: String, buildNumber: String) {
        Crashlytics.crashlytics().setCustomValue(appVersion, forKey: "app_version")
        Crashlytics.crashlytics().setCustomValue(buildNumber, forKey: "build_number")
    }
    
    static func logSessionStarted(entryPoint: String) {
        Analytics.logEvent("session_started", parameters: [
            "entry_point": entryPoint as NSString
        ])
        Crashlytics.crashlytics().log("session_started: \(entryPoint)")
    }
    
    static func logParticipantAdded(total: Int) {
        Analytics.logEvent("participant_added", parameters: [
            "total_participants": NSNumber(value: total)
        ])
    }
    
    static func logParticipantRemoved(total: Int) {
        Analytics.logEvent("participant_removed", parameters: [
            "total_participants": NSNumber(value: total)
        ])
    }
    
    static func logBillAmountEntered(amount: Double, tip: Double, total: Double, tipType: String) {
        Analytics.logEvent("bill_amount_entered", parameters: [
            "amount": amount as NSNumber,
            "tip": tip as NSNumber,
            "total": total as NSNumber,
            "tip_type": tipType as NSString
        ])
    }
    
    static func logSplitMethodSelected(_ method: SplitMethod) {
        Analytics.logEvent("split_method_selected", parameters: [
            "method": method.rawValue as NSString
        ])
        Crashlytics.crashlytics().setCustomValue(method.rawValue, forKey: "current_method")
    }
    
    static func logNewCalculation() {
        Analytics.logEvent("new_calculation", parameters: nil)
        
        Crashlytics.crashlytics().log("new_calculation")
    }
    
    static func logReceiptItemAdded(totalItems: Int) {
        Analytics.logEvent("receipt_item_added", parameters: [
            "items_total": NSNumber(value: totalItems)
        ])
    }
    
    static func logReceiptItemRemoved(totalItems: Int) {
        Analytics.logEvent("receipt_item_removed", parameters: [
            "items_total": NSNumber(value: totalItems)
        ])
    }
    
    static func logPaymentShareAdded(totalShares: Int) {
        Analytics.logEvent("payment_share_added", parameters: [
            "total_shares": NSNumber(value: totalShares)
        ])
        
        Crashlytics.crashlytics().log("payment_share_added: \(totalShares)")
    }
    
    static func logPaymentSharesReset(totalShares: Int) {
        Analytics.logEvent("payment_shares_reset", parameters: [
            "total_shares": NSNumber(value: totalShares)
        ])
        
        Crashlytics.crashlytics().log("payment_shares_reset: \(totalShares)")
    }
    
    static func logBackAttemptWithUnsavedData(screen: String) {
        Analytics.logEvent("back_attempt_with_unsaved_data", parameters: [
            "screen": screen as NSString
        ])
        
        Crashlytics.crashlytics().log("back_attempt_with_unsaved_data: \(screen)")
    }
    
    static func logOnboardingOpened(source: String) { // auto or helpButton
        Analytics.logEvent("onboarding_opened", parameters: [
            "source": source as NSString
        ])
        
        Crashlytics.crashlytics().log("onboarding_opened: \(source)")
    }
    
    static func logBillSplitCompleted(method: SplitMethod,
                                      participants: Int,
                                      items: Int,
                                      totalAmount: Double,
                                      durationSec: Int? = nil,
                                      success: Bool = true) {
        var params: [String: Any] = [
            "method": method.rawValue as NSString,
            "participants_count": NSNumber(value: participants),
            "items_count": NSNumber(value: items),
            "total_amount": totalAmount as NSNumber,
            "success": NSNumber(value: success ? 1 : 0)
        ]
        
        if let durationSec {
            params["duration_sec"] = NSNumber(value: durationSec)
        }
        
        Analytics.logEvent("bill_split_completed", parameters: params)
        Crashlytics.crashlytics().log("bill_split_completed: method=\(method.rawValue), participants=\(participants), items=\(items), total=\(totalAmount), success=\(success)")
    }
    
    static func logShareResult(type: ShareType, method: SplitMethod, isFullyDistributed: Bool) {
        Analytics.logEvent("share_result", parameters: [
            "share_type": type.rawValue as NSString,
            "method": method.rawValue as NSString,
            "fullu_distributed": NSNumber(value: isFullyDistributed)
        ])
    }
    
    static func logScreen(name: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: name as NSString
        ])
    }
    
    static func recordNonFatal(_ error: Error, context: [String: Any]? = nil) {
        if let context {
            for (k, v) in context {
                Crashlytics.crashlytics().setCustomValue(String(describing: v), forKey: "ctx_\(k)")
            }
        }
        Crashlytics.crashlytics().record(error: error)
    }
}
