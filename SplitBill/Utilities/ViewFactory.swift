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
            let billAmountViewModel = BillAmountViewModel(sharedData: sharedData)
            BillAmountView(billAmountViewModel: billAmountViewModel)
        case .calculation:
            let calculationViewModel = CalculationViewModel(sharedData: sharedData)
            CalculationView(calculationViewModel: calculationViewModel)
        }
    }
}
