//
//  BillAmountViewModel.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 29.10.2025.
//

import SwiftUI

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
    
    var tipAmountValue: Double {
        formatter.parse(tipAmount) ?? 0
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
        ValidationService.validateAmount(billAmountValue).isValid
    }
    
    var isValidTipAmount: Bool {
        if !isTipEnable || tipCalculationType == .percentage {
            return true
        }
        
        return ValidationService.validateTipAmount(tipAmountValue).isValid
    }
    
    var tipValidationMessage: String? {
        if !isTipEnable || tipCalculationType == .percentage {
            return nil
        }
        
        let validation = ValidationService.validateTipAmount(tipAmountValue)
        return validation.isValid ? nil : validation.errorMessage
    }
    
    var validationMessage: String {
        let validation = ValidationService.validateAmount(billAmountValue)
        
        if validation.isValid {
            return "Сумма введена корректно"
        } else {
            return validation.errorMessage ?? "Введите сумму от 10 ₽"
        }
    }
    
    var validationIcon: String {
        if billAmountValue == 0 || billAmountValue < 10 {
            return "exclamationmark.circle.fill"
        }
        
        return isValidAmount ? "checkmark.circle.fill" : "exclamationmark.triangle.fill"
    }
    
    var validationIconColor: Color {
        if billAmountValue == 0 || billAmountValue < 10 {
            return .orange
        }
        
        return isValidAmount ? .green : .red
    }
}
