//
//  СalculationView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 31.05.2025.
//

import SwiftUI

struct CalculationView: View {
    
    @Binding var path: NavigationPath
    @EnvironmentObject var data: SharedData
    @State private var currentAmount: String = ""
    @State private var selectedParticipantIndex = 0
    @State private var showAlert = false
    private var pickerOptions: [String] {
        ["На всех"] + data.participants.indices.map { "Уч. \($0 + 1)" }
    }
    var maxCharacters = 6
    
    var body: some View {
        
        VStack {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(data.participants.indices, id: \.self) { index in
                    let participant = data.participants[index]
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 75)
                        .foregroundStyle(Color.blue.gradient)
                        .overlay(
                            VStack {
                                Text("Участник \(index + 1)")
                                    .foregroundStyle(Color.white)
                                    .font(.system(size: 20))
                                
                                Text("\(participant.total) ₽")
                                    .foregroundStyle(Color.white)
                                    .font(.system(size: 18, weight: .bold))
                                
                                if data.tipPercentage > 0 {
                                    let base = participant.baseShares.reduce(0, +)
                                    Text("\(base) ₽ + \(participant.tipShare) ₽ чаевых")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color.white.opacity(0.8))
                                }
                            }
                                .padding(5)
                        )
                }
            }
            .padding()
            
            Spacer()
            
            HStack {
                TextField("Стоимость блюда", text: $currentAmount)
                    .onChange(of: currentAmount) { _, newValue in
                        if newValue.count > maxCharacters {
                            currentAmount = String(newValue.prefix(maxCharacters))
                        }
                    }
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
                addAmount()
            }
            .buttonStyle(.borderedProminent)
            .disabled(currentAmount.isEmpty)
            .padding()
        }
        .navigationTitle("Шаг 3 из 3")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if data.containsAmounts {
                        showAlert = true
                    } else {
                        path.removeLast()
                    }
                } label: {
                    Image(systemName: "chevron.backward")
                    Text("Назад")
                }
                .alert("Вернуться?", isPresented: $showAlert) {
                    Button("Отмена", role: .cancel) {}
                    Button("Сбросить чеки", role: .destructive) {
                        withAnimation {
                            data.resetToInitialState()
                            path = NavigationPath()
                        }
                    }
                }
            }
        }
    }
    
    private func addAmount() {
        guard let amount = Int(currentAmount), amount > 0 else { return }
        
        if selectedParticipantIndex == 0 {
            guard !data.participants.isEmpty else { return }
            
            let perPerson = Int(ceil(Double(amount) / Double(data.participants.count)))
            
            for i in 0..<data.participants.count {
                data.participants[i].baseShares.append(perPerson)
            }
        } else {
            let index = selectedParticipantIndex - 1
            if index < data.participants.count {
                data.participants[index].baseShares.append(amount)
            }
        }
        
        calculateTips()
        currentAmount = ""
    }
    
    private func calculateTips() {
        guard data.tipPercentage > 0 else {
            for i in data.participants.indices {
                data.participants[i].tipShare = 0
            }
            return
        }
        
        let totalBaseAmount = data.participants.reduce(0) { $0 + $1.baseShares.reduce(0, +) }
        let totalTip = Int(ceil(Double(totalBaseAmount) * Double(data.tipPercentage) / 100.0))
        let tipPerPerson = Int(ceil(Double(totalTip) / Double(data.participants.count)))
        
        for i in data.participants.indices {
            data.participants[i].tipShare = tipPerPerson
        }
    }
}

#Preview {
    struct MockView: View {
        @State private var path = NavigationPath()
        
        var body: some View {
            CalculationView(path: $path)
                .environmentObject(SharedData())
        }
    }
    return MockView()
}
