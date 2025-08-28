//
//  TipSelectionView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 26.05.2025.
//

import SwiftUI

struct TipSelectionView: View {
    
    @State private var billAmount = ""
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
    
    private var totalAmount: Double {
        let amount: Double
        if let number = numberFormatter.number(from: billAmount) {
            amount = number.doubleValue
        } else {
            return 0
        }
        
        let tip = data.isTipEnable ? amount * data.tipPercentage / 100 : 0
        return amount + tip
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
                        HStack {
                            Text("Процент:")
                            Slider(value: $data.tipPercentage, in: 0...30, step: 1)
                            Text("\(Int(data.tipPercentage))%")
                                .frame(width: 40, alignment: .trailing)
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
            .scrollDisabled(true)
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
