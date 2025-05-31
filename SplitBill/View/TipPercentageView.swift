//
//  TipPercentageView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 26.05.2025.
//

import SwiftUI

struct TipPercentageView: View {
    var body: some View {
        VStack {
            Text("Slider (TipPercentage)")
            NavigationLink("Next step", destination: CalculationView())
        }
        .navigationTitle("Чаевые")
    }
}

#Preview { 
    TipPercentageView()
}
