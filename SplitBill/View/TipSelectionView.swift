//
//  TipSelectionView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 26.05.2025.
//

import SwiftUI

struct TipSelectionView: View {
    
    @Binding var path: NavigationPath
    @EnvironmentObject var data: SharedData
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Чаевые \(data.tipPercentage, specifier: "%.0f")%")
            Slider(value: $data.tipPercentage, in: 0...30, step: 1)
                .padding()
            Spacer()
            
            Button(action: {
                path.append(Route.calculation)
            }) {
                Text("Далее")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .padding()
        }
        .navigationTitle("Шаг 2 из 3")
    }
}

#Preview {
    struct MockView: View {
        @State private var path = NavigationPath()
        
        var body: some View {
             TipSelectionView(path: $path)
                .environmentObject(SharedData())
        }
    }
    return MockView()
}
