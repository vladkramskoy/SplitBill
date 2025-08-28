//
//  TipSelectionView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 26.05.2025.
//

import SwiftUI

struct TipSelectionView: View {
    
    @State private var billAmount = ""
    @State private var tipCalculationType: TipCalculationType = .percentage
    @Binding var path: NavigationPath
    @EnvironmentObject var data: SharedData
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimum = 0
        formatter.locale = Locale.current
        return formatter
    }()
    
    private var calculatedTip: Double {
        guard data.isTipEnable else { return 0 }
        
        if tipCalculationType == .percentage {
            guard let amount = numberFormatter.number(from: billAmount)?.doubleValue else { return 0 }
            
            return amount * data.tipPercentage / 100
        } else {
            return Double(data.tipAmount) ?? 0
        }
    }
    
    private var totalAmount: Double {
        guard let amount = numberFormatter.number(from: billAmount)?.doubleValue else { return 0 }
        return amount + calculatedTip
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Сумма счёта", text: $billAmount)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Сумма счёта")
                }
                
                Section {
                    Toggle("Добавить чаевые", isOn: $data.isTipEnable)
                    
                    if data.isTipEnable {
                        Picker("Способ расчета", selection: $tipCalculationType) {
                            ForEach(TipCalculationType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if tipCalculationType == .percentage {
                            HStack {
                                Text("Процент:")
                                Slider(value: $data.tipPercentage, in: 0...30, step: 1)
                                Text("\(Int(data.tipPercentage))%")
                                    .frame(width: 40, alignment: .trailing)
                            }
                        } else {
                            HStack {
                                Text("Сумма:")
                                TextField("0.00", text: $data.tipAmount)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                            }
                        }

                        HStack {
                            Text("Сумма с чаевыми:")
                            Spacer()
                            Text(totalAmount, format: .currency(code: "RUB"))
                        }
                    }
                } header: {
                    Text("Чаевые")
                }
            }
            .padding()
            
            Button(action: {
                path.append(Route.calculation)
            }) {
                Text("Далее")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .padding()
        }
        .navigationTitle("Шаг 2 из 3")
    }
}

#Preview {
    struct MockView: View {
        @State private var path = NavigationPath()
        
        var body: some View {
             TipSelectionView(path: $path)
                .environmentObject(SharedData())
        }
    }
    return MockView()
}
