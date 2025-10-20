//
//  SharedData.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 22.05.2025.
//

import Foundation

final class SharedData: ObservableObject {
    @Published var participants: [Participant] = []
    @Published var billAmount = ""
    @Published var tipCalculationType: TipCalculationType = .percentage
    @Published var tipPercentage = 15.0
    @Published var tipAmount = ""
    @Published var isTipEnable = false
    @Published var currentAmount: String = ""
    @Published var selectedParticipantIndex = 0
    @Published var nameInput: String = ""

    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimum = 0
        formatter.locale = Locale.current
        return formatter
    }()
    
    var billAmountConvertInDouble: Double {
        guard let amount = numberFormatter.number(from: billAmount)?.doubleValue else { return 0 }
        return amount
    }
    
    var calculatedTip: Double {
        guard isTipEnable else { return 0 }
        
        if tipCalculationType == .percentage {
            guard let amount = numberFormatter.number(from: billAmount)?.doubleValue else { return 0 }
            
            return amount * tipPercentage / 100
        } else {
            guard let tipAmount = numberFormatter.number(from: tipAmount)?.doubleValue else { return 0 }
            return tipAmount
        }
    }
    
    var totalAmount: Double {
        guard let amount = numberFormatter.number(from: billAmount)?.doubleValue else { return 0 }
        return amount + calculatedTip
    }
    
    var isValidAmount: Bool {
        if billAmount.isEmpty {
            return false
        }
        guard let number = numberFormatter.number(from: billAmount)?.doubleValue else { return false }
        return number >= 10
    }
    
    var amountPerPerson: Double {
        guard !participants.isEmpty else { return 0 }
        return totalAmount / Double(participants.count)
    }
    
    // TODO: process refactor
    
//    var containsAmounts: Bool {
//        participants.contains { !$0.baseShares.isEmpty }
//    }
    
    func addParticipant(for name: String) {
        let participant = Participant(name: name)
        participants.append(participant)
        nameInput = ""
    }
    
    func removeParticipant(at offsets: IndexSet) {
        participants.remove(atOffsets: offsets)
    }
    
    func formatBillAmount(_ imput: String) -> String {
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
    
    func resetToInitialState() {
        participants = []
        billAmount = ""
        tipPercentage = 15.0
        tipAmount = ""
        isTipEnable = false
    }
}
