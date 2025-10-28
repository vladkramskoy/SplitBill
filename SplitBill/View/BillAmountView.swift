//
//  BillAmountView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 26.05.2025.
//

import SwiftUI

struct BillAmountView: View {
    @Environment(Router.self) private var router
    @EnvironmentObject private var sharedData: SharedData
    
    @State private var textColor: Color = .red
    @FocusState private var isAmountFocused: Bool
    @FocusState private var isTipFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Сумма чека")
                    .font(.headline)
                    .foregroundStyle(.gray)
                
                TextField("0 ₽", text: $sharedData.billAmount)
                    .font(.system(size: 40, weight: .bold))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .focused($isAmountFocused)
                    .foregroundStyle(textColor)
                    .onChange(of: sharedData.billAmount) { oldValue, newValue in
                        let formatted = InputValidator.formatCurrencyInput(newValue)
                        if formatted != newValue {
                            sharedData.billAmount = formatted
                        }
                        
                        textColor = sharedData.isValidAmount ? .green : .red
                    }
                    .onAppear {
                        textColor = sharedData.isValidAmount ? .green : .red
                    }
            }
            .padding(.horizontal)
            .padding(.top, 30)
            
            Toggle("Добавить чаевые", isOn: $sharedData.isTipEnable)
                .padding(.horizontal)
                .onChange(of: sharedData.isTipEnable) { _, isOn in
                    if isOn {
                        if sharedData.tipCalculationType == .fixedAmount {
                            isTipFocused = true
                        }
                    } else {
                        isAmountFocused = true
                    }
                }
            
            if sharedData.isTipEnable {
                Picker("Способ расчета", selection: $sharedData.tipCalculationType) {
                    ForEach(TipCalculationType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .onChange(of: sharedData.tipCalculationType) { _, newValue in
                    if newValue == .percentage {
                        isAmountFocused = true
                    } else {
                        isTipFocused = true
                    }
                }
                
                if sharedData.tipCalculationType == .percentage {
                    HStack {
                        Text("Процент:")
                        Slider(value: $sharedData.tipPercentage, in: 0...30, step: 1)
                            .onChange(of: sharedData.tipPercentage) { _, newValue in
                                sharedData.tipPercentage = round(newValue)
                            }
                        Text("\(Int(sharedData.tipPercentage))%")
                            .frame(width: 40, alignment: .trailing)
                    }
                    .padding(.horizontal)
                } else {
                    HStack {
                        Text("Сумма:")
                        TextField("0.00", text: $sharedData.tipAmount)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($isTipFocused)
                            .onChange(of: sharedData.tipAmount) { oldValue, newValue in
                                let formatted = InputValidator.formatCurrencyInput(newValue)
                                if formatted != newValue {
                                    sharedData.tipAmount = formatted
                                }
                            }
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    Text("Сумма с чаевыми:")
                    Spacer()
                    Text(sharedData.amountWithTips, format: .currency(code: "RUB"))
                }
                .padding(.horizontal)
            }
            
            Button(action: {
                router.navigateToSplitMethod()
            }) {
                Text("Продолжить")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(sharedData.isValidAmount ? Color.blue : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .disabled(!sharedData.isValidAmount)
            .padding()
            
            Spacer()
        }
        .navigationTitle("Введите сумму")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isAmountFocused = true
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @StateObject var sharedData = SharedData()
    
    BillAmountView()
        .environmentObject(sharedData)
        .withRouter()
}
