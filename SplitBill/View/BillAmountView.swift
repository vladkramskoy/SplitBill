//
//  BillAmountView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 26.05.2025.
//

import SwiftUI

struct BillAmountView: View {
    @Environment(Router.self) private var router
    @Environment(BillSession.self) private var session
    @StateObject private var viewModel = BillAmountViewModel()
    @State private var textColor: Color = .red
    @FocusState private var isAmountFocused: Bool
    @FocusState private var isTipFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Сумма чека")
                    .font(.headline)
                    .foregroundStyle(.gray)
                
                TextField("0 ₽", text: $viewModel.billAmount)
                    .font(.system(size: 40, weight: .bold))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .focused($isAmountFocused)
                    .foregroundStyle(textColor)
                    .onChange(of: viewModel.billAmount) { oldValue, newValue in
                        let formatted = InputValidator.formatCurrencyInput(newValue)
                        if formatted != newValue {
                            viewModel.billAmount = formatted
                        }
                        
                        textColor = viewModel.isValidAmount ? .green : .red
                    }
                    .onAppear {
                        textColor = viewModel.isValidAmount ? .green : .red
                    }
            }
            .padding(.horizontal)
            .padding(.top, 30)
            
            Toggle("Добавить чаевые", isOn: $viewModel.isTipEnable)
                .padding(.horizontal)
                .onChange(of: viewModel.isTipEnable) { _, isOn in
                    if isOn {
                        if viewModel.tipCalculationType == .fixedAmount {
                            isTipFocused = true
                        }
                    } else {
                        isAmountFocused = true
                    }
                }
            
            if viewModel.isTipEnable {
                Picker("Способ расчета", selection: $viewModel.tipCalculationType) {
                    ForEach(TipCalculationType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .onChange(of: viewModel.tipCalculationType) { _, newValue in
                    if newValue == .percentage {
                        isAmountFocused = true
                    } else {
                        isTipFocused = true
                    }
                }
                
                if viewModel.tipCalculationType == .percentage {
                    HStack {
                        Text("Процент:")
                        Slider(value: $viewModel.tipPercentage, in: 0...30, step: 1)
                            .onChange(of: viewModel.tipPercentage) { _, newValue in
                                viewModel.tipPercentage = round(newValue)
                            }
                        Text("\(Int(viewModel.tipPercentage))%")
                            .frame(width: 40, alignment: .trailing)
                    }
                    .padding(.horizontal)
                } else {
                    HStack {
                        Text("Сумма:")
                        TextField("0.00", text: $viewModel.tipAmount)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($isTipFocused)
                            .onChange(of: viewModel.tipAmount) { oldValue, newValue in
                                let formatted = InputValidator.formatCurrencyInput(newValue)
                                if formatted != newValue {
                                    viewModel.tipAmount = formatted
                                }
                            }
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    Text("Сумма с чаевыми:")
                    Spacer()
                    Text(viewModel.totalAmount, format: .currency(code: "RUB"))
                }
                .padding(.horizontal)
            }
            
            Button(action: {
                session.billAmount = viewModel.billAmountValue
                session.tipAmount = viewModel.calculatedTip
                session.totalAmount = viewModel.totalAmount
                
                AnalyticsService.logBillAmountEntered(
                    amount: viewModel.billAmountValue,
                    tip: viewModel.calculatedTip,
                    total: viewModel.totalAmount,
                    tipType: viewModel.isTipEnable ? viewModel.tipCalculationType.rawValue : "none"
                )
                
                router.navigateToSplitMethod()
            }) {
                Text("Продолжить")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(viewModel.isValidAmount ? Color.blue : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .disabled(!viewModel.isValidAmount)
            .padding()
            
            Spacer()
        }
        .navigationTitle("Введите сумму")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isAmountFocused = true
            AnalyticsService.logScreen(name: "bill_amount_screen")
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var session = BillSession()
    
    BillAmountView()
        .environment(session)
        .withRouter()
}
