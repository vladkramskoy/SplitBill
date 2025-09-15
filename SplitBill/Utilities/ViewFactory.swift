//
//  ViewFactory.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 14.09.2025.
//

import SwiftUI

struct ViewFactory {
    @ViewBuilder
    
    static func makeView(for route: Route, sharedData: SharedData) -> some View {
        switch route {
        case .tipSelection:
            TipSelectionView()
        case .calculation:
            CalculationView()
        }
    }
}
