//
//  TipPercentageView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 26.05.2025.
//

import SwiftUI

struct TipPercentageView: View {
    
    @StateObject var viewModel = TipPercentageViewViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Чаевые \(viewModel.tipPercent, specifier: "%.0f")%")
            Slider(value: $viewModel.tipPercent, in: 0...30, step: 1)
                .padding()
            Spacer()
            
            NavigationLink("Далее", destination: CalculationView())
                .padding(.bottom, 125)
        }
        .navigationTitle("Чаевые")
    }
}

#Preview { 
    TipPercentageView()
}
