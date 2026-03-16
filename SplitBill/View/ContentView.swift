//
//  ContentView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 14.09.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var session = BillSession()
    @State private var showWelcomeOnboarding = false
    @AppStorage("currencyCode") private var currencyCode: String = "RUS"
    
    private var formatter: DecimalFormatting {
        DecimalFormatter(currencyCode: currencyCode)
    }
    
    var body: some View {
        ParticipantView()
            .withRouter()
            .environment(session)
            .environment(\.decimalFormatter, formatter)
            .onAppear {
                AnalyticsService.logSessionStarted(entryPoint: "app_launch")
                showWelcomeOnboarding = OnboardingManager.shouldShowOnboarding
            }
            .sheet(isPresented: $showWelcomeOnboarding) {
                WelcomeOnboardingView()
            }
    }
}

#Preview {
    ContentView()
}
