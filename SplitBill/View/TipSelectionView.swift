//
//  TipSelectionView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 26.05.2025.
//

import SwiftUI

struct TipSelectionView: View {
    
    @EnvironmentObject var data: SharedData
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Чаевые \(data.tipPercentage, specifier: "%.0f")%")
            Slider(value: $data.tipPercentage, in: 0...30, step: 1)
                .padding()
            Spacer()
            
            NavigationLink("Далее", destination: CalculationView())
                .padding(.bottom, 125)
        }
        .navigationTitle("Чаевые")
    }
}

#Preview {
    let sharedData = SharedData()
    
    TipSelectionView()
        .environmentObject(sharedData)
}
