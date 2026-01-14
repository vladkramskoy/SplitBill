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
    @State private var amountColor: Color = .secondary
    @FocusState private var isAmountFocused: Bool
    @FocusState private var isTipFocused: Bool
    
    var body: some View {
        ZStack {
            Color.SplitBill.backgroundLight
                .ignoresSafeArea()
            
            VStack {
                VStack(spacing: 16) {
                    headerCard
                    amountInputCard
                    tipToggleCard
                }

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        isAmountFocused = false
                        isTipFocused = false
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                }
            }
            .onAppear {
                isAmountFocused = true
                updateAmountGradient()
                AnalyticsService.logScreen(name: "bill_amount_screen")
            }
            
            VStack {
                Spacer()
                
                NextButton(title: "Продолжить", action: {
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
                }, isActive: viewModel.isValidAmount && viewModel.isValidTipAmount)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    // MARK: Header Card
    
    private var headerCard: some View {
        VStack(spacing: 16) {
            Text("Сумма счёта")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Введите общую сумму чека")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.bottom, 8)
    }
    
    // MARK: Amount Input Card
    
    private var amountInputCard: some View {
        VStack(spacing: 16) {
            Text("Сумма чека")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                TextField("0", text: $viewModel.billAmount)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .focused($isAmountFocused)
                    .foregroundStyle(amountColor)
                    .onChange(of: viewModel.billAmount) { oldValue, newValue in
                        let formatted = InputValidator.formatCurrencyInput(newValue)
                        if formatted != newValue {
                            viewModel.billAmount = formatted
                        }
                        updateAmountGradient()
                    }
                
                Text("₽")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary.opacity(0.5))
            }
            
            HStack(spacing: 8) {
                let iconColor = viewModel.validationIconColor
                
                Image(systemName: viewModel.validationIcon)
                    .foregroundStyle(iconColor)

                Text(viewModel.validationMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 12, y: 6)
        .padding(.horizontal)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(!viewModel.isValidAmount && viewModel.billAmountValue > 999_999.99 ? Color.red.opacity(0.6) : Color.clear, lineWidth: 2)
                .padding(.horizontal)
        }
    }
    
    // MARK: Tip Toggle Card
    
    private var tipToggleCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Добавить чаевые")
                    .font(.headline)
                
                Spacer()
                
                Toggle("", isOn: $viewModel.isTipEnable)
                    .labelsHidden()
                    .onChange(of: viewModel.isTipEnable) { _, isOn in
                        if isOn {
                            if viewModel.tipCalculationType == .fixedAmount {
                                isTipFocused = true
                            }
                        } else {
                            isAmountFocused = true
                        }
                    }
            }
            
            if viewModel.isTipEnable {
                Divider()
                
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
                        Text("Процент чаевых:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("\(Int(viewModel.tipPercentage))%")
                            .frame(width: 40, alignment: .trailing)
                            .font(.headline)
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Slider(value: $viewModel.tipPercentage, in: 0...30, step: 1)
                        .tint(.blue)
                        .onChange(of: viewModel.tipPercentage) { _, newValue in
                            viewModel.tipPercentage = round(newValue)
                        }
                    
                    HStack(spacing: 8) {
                        ForEach([5, 10, 15, 20], id: \.self) { percentage in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    viewModel.tipPercentage = Double(percentage)
                                }
                            }) {
                                Text("\(percentage)%")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Int(viewModel.tipPercentage) == percentage ? .white : .blue)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Int(viewModel.tipPercentage) == percentage ? .blue : .blue.opacity(0.1))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                } else {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Сумма чаевых:")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                        }
                        
                        HStack {
                            TextField("0", text: $viewModel.tipAmount)
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .focused($isTipFocused)
                                .foregroundStyle(.blue)
                                .onChange(of: viewModel.tipAmount) { oldValue, newValue in
                                    let formatted = InputValidator.formatCurrencyInput(newValue)
                                    if formatted != newValue {
                                        viewModel.tipAmount = formatted
                                    }
                                }
                            
                            Text("₽")
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                                .foregroundStyle(.secondary.opacity(0.5))
                        }
                        .padding()
                        .background(.blue.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(!viewModel.isValidTipAmount && viewModel.tipAmountValue > 999_999.99 ? Color.red.opacity(0.6) : Color.clear, lineWidth: 2)
                        }
                        
                        if let errorMessage = viewModel.tipValidationMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                }

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Итого с чаевыми:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text(viewModel.totalAmount, format: .currency(code: "RUB"))
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    if viewModel.calculatedTip > 0 {
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Чаевые")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Text(viewModel.calculatedTip, format: .currency(code: "RUB"))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 12, y: 6)
        .padding(.horizontal)
    }
    
    private func updateAmountGradient() {
        amountColor = viewModel.isValidAmount
        ? .green.opacity(0.9)
        : .red.opacity(0.7)
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var session = BillSession()
    
    BillAmountView()
        .environment(session)
        .withRouter()
}
