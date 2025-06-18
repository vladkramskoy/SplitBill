//
//  СalculationView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 31.05.2025.
//

import SwiftUI

struct CalculationView: View {
    
    @EnvironmentObject var data: SharedData
    @State private var currentAmount: String = ""
    
    var body: some View {
        
        VStack {
            ForEach(data.participants.indices, id: \.self) { index in
                
                let participant = data.participants[index]
                let amount = participant.share.reduce(0, +)
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 320, height: 100)
                    .foregroundStyle(Color.blue)
                    .overlay(
                        VStack {
                            Text("Участник \(index + 1)")
                                .foregroundStyle(Color(UIColor { traitCollection in
                                    traitCollection.userInterfaceStyle == .dark ? .black : .white
                                }))
                                .font(.system(size: 20))
                            Text("\(amount) ₽")
                                .foregroundStyle(Color(UIColor { traitCollection in
                                    traitCollection.userInterfaceStyle == .dark ? .black : .white
                                }))
                        }
                    )
            }
            
            Spacer()
            
            TextField("Стоимость блюда", text: $currentAmount)
                .keyboardType(.decimalPad)
            
            Spacer()
            
            Button("Добавить") {
                guard let amount = Double(currentAmount) else { return }
                data.participants[0].share.append(amount)
                currentAmount = ""
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    let sharedData = SharedData()
    
    CalculationView()
        .environmentObject(sharedData)
}
