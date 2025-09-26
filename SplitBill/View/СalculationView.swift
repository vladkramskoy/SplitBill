//
//  СalculationView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 31.05.2025.
//

import SwiftUI

struct CalculationView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var sharedData: SharedData
    @State private var showAlert = false
    @State private var isExpanded = false
    @FocusState private var isTextFieldFocused: Bool
    
    private var pickerOptions: [String] {
        ["На всех"] + sharedData.participants.indices.map { "Уч. \($0 + 1)" }
    }
    
    var maxCharacters = 6
    
    var body: some View {
        
        VStack {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(sharedData.participants.indices, id: \.self) { index in
                    let participant = sharedData.participants[index]
                    
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
                                
                                if sharedData.isTipEnable && sharedData.tipPercentage > 0 {
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
                        Text("\(sharedData.calculationTotalAmount) ₽")
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
                        
                        DetailRow(title: "Чаевые", value: sharedData.calculationTotalTipAmount)
                        DetailRow(title: "Без чаевых", value: sharedData.calculationTotalBaseAmount)
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
                TextField("0₽", text: $sharedData.currentAmount)
                    .onChange(of: sharedData.currentAmount) { _, newValue in
                        if newValue.count > maxCharacters {
                            sharedData.currentAmount = String(newValue.prefix(maxCharacters))
                        }
                    }
                
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(40)
                    .focused($isTextFieldFocused)
                    .keyboardType(.numberPad)
                    .padding()
                
                Picker("", selection: $sharedData.selectedParticipantIndex) {
                    ForEach(0..<pickerOptions.count, id: \.self) { index in
                        Text(pickerOptions[index]).tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 100)
                .clipped()
                
                Button(action: {
                    sharedData.addAmount()
                }) {
                    Image(systemName: "arrow.up")
                }
                .disabled(sharedData.currentAmount.isEmpty)
                .font(.title)
                .foregroundColor(sharedData.currentAmount.isEmpty ? .gray : .white)
                .frame(width: 50, height: 50)
                .background(sharedData.currentAmount.isEmpty ? .gray.opacity(0.2) : .blue)
                .clipShape(Circle())
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 40, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
            .padding(.bottom)
        }
        .navigationTitle("Шаг 3 из 3")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if sharedData.containsAmounts {
                        showAlert = true
                    } else {
                        coordinator.pop()
                    }
                } label: {
                    Image(systemName: "chevron.backward")
                    Text("Назад")
                }
                .alert("Вернуться?", isPresented: $showAlert) {
                    Button("Отмена", role: .cancel) {}
                    Button("Сбросить чеки", role: .destructive) {
                        withAnimation {
                            sharedData.resetToInitialState()
                            coordinator.popToRoot()
                        }
                    }
                }
            }
            
            ToolbarItemGroup(placement: .keyboard) {
                Button {
                    isTextFieldFocused = false
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
                Spacer()
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var sharedData = SharedData()
    @Previewable @StateObject var coordinator = Coordinator()
    
    CalculationView()
        .environmentObject(sharedData)
        .environmentObject(coordinator)
}
