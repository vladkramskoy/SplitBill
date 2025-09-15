//
//  ContentView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 14.09.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = Coordinator()
    @StateObject private var sharedData = SharedData()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ParticipantView(participantViewModel: ParticipantViewModel(sharedData: sharedData))
                .navigationDestination(for: Route.self) { route in
                    ViewFactory.makeView(for: route, sharedData: sharedData)
                }
        }
        .environmentObject(sharedData)
        .environmentObject(coordinator)
    }
}

#Preview {
    ContentView()
}
