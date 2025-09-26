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
        case .billAmount:
            BillAmountView()
        case .calculation:
            let calculationViewModel = CalculationViewModel(sharedData: sharedData)
            CalculationView(calculationViewModel: calculationViewModel)
        }
    }
}
