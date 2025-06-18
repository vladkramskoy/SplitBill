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
    @State private var selectedParticipantIndex = 0
    private var pickerOptions: [String] {
        ["На всех"] + data.participants.indices.map { "Уч. \($0 + 1)" }
    }
    
    var body: some View {
        
        VStack {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(data.participants.indices, id: \.self) { index in
                    
                    let participant = data.participants[index]
                    let amount = participant.share.reduce(0, +)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 75)
                    
                        .foregroundStyle(Color.blue.gradient)
                    
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
                

            }
            .padding()
            
            Spacer()
            
            HStack {
                TextField("Стоимость блюда", text: $currentAmount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Picker("", selection: $selectedParticipantIndex) {
                    ForEach(0..<pickerOptions.count, id: \.self) { index in
                        Text(pickerOptions[index]).tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 150)
                .clipped()
            }
            
            Button("Добавить") {
                guard let amount = Int(currentAmount) else { return }
                data.participants[0].share.append(amount)
                currentAmount = ""
            }
            .buttonStyle(.borderedProminent)
            .disabled(currentAmount.isEmpty)
            .padding()
        }
    }
}

#Preview {
    let sharedData = SharedData()
    
    CalculationView()
        .environmentObject(sharedData)
}
