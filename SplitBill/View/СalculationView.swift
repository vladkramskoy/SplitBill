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
    @State private var isExpanded = false
    @FocusState private var isTextFieldFocused: Bool
    
    private var pickerOptions: [String] {
        ["На всех"] + data.participants.indices.map { "Уч. \($0 + 1)" }
    }
    
    var maxCharacters = 6
    
    var body: some View {
        
        VStack {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(data.participants.indices, id: \.self) { index in
                    let participant = data.participants[index]
                    
                    RoundedRectangle(cornerRadius: 12)
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
                                    Text("\(base) ₽ + \(participant.tipShares.reduce(0, +)) ₽ чаевых")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color.white.opacity(0.8))
                                }
                            }
                                .padding(5)
                        )
                }
            }
            .padding()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Общая сумма")
                        .font(.headline)
                    
                    Spacer()
                    
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text("\(data.totalAmount) ₽")
                            .fontWeight(.bold)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption.weight(.medium))
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isExpanded.toggle()
                    }
                }
                
                if isExpanded {
                    VStack(alignment: .leading, spacing: 6) {
                        Divider()
                        
                        DetailRow(title: "Чаевые", value: data.totalTipAmount)
                        DetailRow(title: "Без чаевых", value: data.totalBaseAmount)
                        Divider()
                        
                        Text("Суммы округлены для удобства. Возможна небольшая погрешность.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
            
            HStack {
                TextField("Стоимость блюда", text: $currentAmount)
                    .onChange(of: currentAmount) { _, newValue in
                        if newValue.count > maxCharacters {
                            currentAmount = String(newValue.prefix(maxCharacters))
                        }
                    }
                    .focused($isTextFieldFocused)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
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
            
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button {
                    isTextFieldFocused = false
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
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
                data.participants[i].tipShares = Array(repeating: 0, count: data.participants[i].baseShares.count)
            }
            return
        }
        
        for i in data.participants.indices {
            data.participants[i].tipShares = data.participants[i].baseShares.map { base in
                let tip = Int(ceil(Double(base) * data.tipPercentage / 100.0))
                return tip
            }
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
