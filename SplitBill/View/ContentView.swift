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
    
    var body: some View {
        ParticipantView()
            .withRouter()
            .environment(session)
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
