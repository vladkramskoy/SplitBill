//
//  СalculationView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 31.05.2025.
//

import SwiftUI

struct CalculationView: View {
    
    @EnvironmentObject var data: SharedData
    @Environment(\.dismiss) private var dismiss
    @State private var currentAmount: String = ""
    @State private var selectedParticipantIndex = 0
    @State private var showAlert = false
    private var pickerOptions: [String] {
        ["На всех"] + data.participants.indices.map { "Уч. \($0 + 1)" }
    }
    private var maxCharacters = 7
        
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
                    if data.participants.contains(where: { !$0.share.isEmpty }) {
                        showAlert = true
                    } else {
                        dismiss()
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
                            dismiss()
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
            
            let totalAmount = data.tipPercentage > 0 ?
            amount + (amount * Int(data.tipPercentage) / 100) :
            amount
            
            let sharePerPerson = totalAmount/data.participants.count
            
            for i in 0..<data.participants.count {
                data.participants[i].share.append(sharePerPerson)
            }
        } else {
            let participantIndex = selectedParticipantIndex - 1
            if participantIndex < data.participants.count {
                let amountToAdd = data.tipPercentage > 0 ?
                amount + (amount * Int(data.tipPercentage) / 100) :
                amount
                data.participants[participantIndex].share.append(amountToAdd)
            }
        }
        
        currentAmount = ""
    }
}

#Preview {
    let sharedData = SharedData()
    
    CalculationView()
        .environmentObject(sharedData)
}
