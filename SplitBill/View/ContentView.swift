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
            ParticipantView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .tipSelection:
                        TipSelectionView()
                    case .calculation:
                        CalculationView()
                    }
                }
        }
        .environmentObject(sharedData)
        .environmentObject(coordinator)
    }
}

#Preview {
    ContentView()
}
