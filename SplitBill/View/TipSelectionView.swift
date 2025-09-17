//
//  TipSelectionView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 26.05.2025.
//

import SwiftUI

struct TipSelectionView: View {
    @State private var tipCalculationType: TipCalculationType = .percentage
    @EnvironmentObject private var coordinator: Coordinator
    @ObservedObject var tipSelectionViewModel: TipSelectionViewModel
    
    @FocusState private var isAmountFocused: Bool
    @FocusState private var isTipFocused: Bool
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimum = 0
        formatter.locale = Locale.current
        return formatter
    }()
    
    private var calculatedTip: Double {
        guard tipSelectionViewModel.shareData.isTipEnable else { return 0 }
        
        if tipCalculationType == .percentage {
            guard let amount = numberFormatter.number(from: tipSelectionViewModel.shareData.billAmount)?.doubleValue else { return 0 }
            
            return amount * tipSelectionViewModel.shareData.tipPercentage / 100
        } else {
            guard let tipAmount = numberFormatter.number(from: tipSelectionViewModel.shareData.tipAmount)?.doubleValue else { return 0 }
            return tipAmount
        }
    }
    
    private var totalAmount: Double {
        guard let amount = numberFormatter.number(from: tipSelectionViewModel.shareData.billAmount)?.doubleValue else { return 0 }
        return amount + calculatedTip
    }
    
    private var isValidAmount: Bool {
        if tipSelectionViewModel.shareData.billAmount.isEmpty {
            return false
        }
        guard let number = numberFormatter.number(from: tipSelectionViewModel.shareData.billAmount)?.doubleValue else { return false }
        return number >= 10
    }

    private func formatBillAmount(_ imput: String) -> String {
        if imput.count > 10 {
            return String(imput.prefix(10))
        }
        
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        let allowedCharacters = CharacterSet(charactersIn: "0123456789" + decimalSeparator)
        
        let filtered = imput.filter { char in
            let stringChar = String(char)
            return stringChar.rangeOfCharacter(from: allowedCharacters) != nil
        }
        
        let normalized = filtered.replacingOccurrences(of: decimalSeparator == "." ? "," : ".", with: decimalSeparator)
        let components = normalized.components(separatedBy: decimalSeparator)
        
        if components.count > 2 {
            let firstPart = components[0]
            let remaining = components[1...].joined()
            return firstPart + decimalSeparator + remaining
        }
        
        if components.count == 2 {
            let integerPart = components[0]
            let fractionalPart = String(components[1].prefix(2))
            return integerPart + decimalSeparator + fractionalPart
        }
        
        return normalized
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Сумма чека")
                    .font(.headline)
                    .foregroundStyle(.gray)
                
                TextField("0 ₽", text: $tipSelectionViewModel.shareData.billAmount)
                    .font(.system(size: 40, weight: .bold))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .focused($isAmountFocused)
                    .foregroundStyle(isValidAmount ? Color.green : Color.red)
                    .onChange(of: tipSelectionViewModel.shareData.billAmount) { oldValue, newValue in
                        let formatted = formatBillAmount(newValue)
                        if formatted != newValue {
                            tipSelectionViewModel.shareData.billAmount = formatted
                        }
                    }
            }
            .padding(.horizontal)
            .padding(.top, 30)
            
            Toggle("Добавить чаевые", isOn: $tipSelectionViewModel.shareData.isTipEnable)
                .padding(.horizontal)
                .onChange(of: tipSelectionViewModel.shareData.isTipEnable) { _, isOn in
                    if isOn {
                        if tipCalculationType == .fixedAmount {
                            isTipFocused = true
                        }
                    } else {
                        isAmountFocused = true
                    }
                }
            
            if tipSelectionViewModel.shareData.isTipEnable {
                Picker("Способ расчета", selection: $tipCalculationType) {
                    ForEach(TipCalculationType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .onChange(of: tipCalculationType) { _, newValue in
                    if newValue == .percentage {
                        isAmountFocused = true
                    } else {
                        isTipFocused = true
                    }
                }
                
                if tipCalculationType == .percentage {
                    HStack {
                        Text("Процент:")
                        Slider(value: $tipSelectionViewModel.shareData.tipPercentage, in: 0...30, step: 1)
                            .onChange(of: tipSelectionViewModel.shareData.tipPercentage) { _, newValue in
                                tipSelectionViewModel.shareData.tipPercentage = round(newValue)
                            }
                        Text("\(Int(tipSelectionViewModel.shareData.tipPercentage))%")
                            .frame(width: 40, alignment: .trailing)
                    }
                    .padding(.horizontal)
                } else {
                    HStack {
                        Text("Сумма:")
                        TextField("0.00", text: $tipSelectionViewModel.shareData.tipAmount)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($isTipFocused)
                            .onChange(of: tipSelectionViewModel.shareData.tipAmount) { oldValue, newValue in
                                let formatted = formatBillAmount(newValue)
                                if formatted != newValue {
                                    tipSelectionViewModel.shareData.tipAmount = formatted
                                }
                            }
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    Text("Сумма с чаевыми:")
                    Spacer()
                    Text(totalAmount, format: .currency(code: "RUB"))
                }
                .padding(.horizontal)
            }
            
            Button(action: {
                coordinator.push(Route.calculation)
            }) {
                Text("Продолжить")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(isValidAmount ? Color.blue : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .disabled(!isValidAmount)
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

#Preview {
    @Previewable @StateObject var sharedData = SharedData()
    @Previewable @StateObject var coordinator = Coordinator()
    
    TipSelectionView(tipSelectionViewModel: TipSelectionViewModel(sharedData: sharedData))
        .environmentObject(sharedData)
        .environmentObject(coordinator)
}
