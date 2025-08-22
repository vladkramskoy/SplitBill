//
//  SplitBillApp.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 21.05.2025.
//

import SwiftUI

@main
struct SplitBillApp: App {
    
    @StateObject private var data = SharedData()
    @State private var path = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                ParticipantView(path: $path)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .tipSelection:
                            TipSelectionView(path: $path)
                        case .calculation:
                            CalculationView(path: $path)
                        }
                    }
            }
            .environmentObject(data)
        }
    }
}
