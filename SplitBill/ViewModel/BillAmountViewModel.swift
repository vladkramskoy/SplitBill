//
//  BillAmountViewModel.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 29.10.2025.
//

import Foundation

final class BillAmountViewModel: ObservableObject {
    @Published var billAmount = ""
    @Published var tipCalculationType: TipCalculationType = .percentage
    @Published var tipPercentage = 15.0
    @Published var tipAmount = ""
    @Published var isTipEnable = false
    
    private var formatter: DecimalFormatting
    
    init(formatter: DecimalFormatting = DecimalFormatter()) {
        self.formatter = formatter
    }
    
    var billAmountValue: Double {
        formatter.parse(billAmount) ?? 0
    }
    
    var calculatedTip: Double {
        guard isTipEnable else { return 0 }
        
        if tipCalculationType == .percentage {
            return billAmountValue * tipPercentage / 100
        } else {
            return formatter.parse(tipAmount) ?? 0
        }
    }
    
    var totalAmount: Double {
        billAmountValue + calculatedTip
    }
    
    var isValidAmount: Bool {
        billAmountValue >= 10
    }
}
