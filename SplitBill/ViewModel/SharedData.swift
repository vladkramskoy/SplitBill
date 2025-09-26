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
    
    let minParticipants = 2
    let maxParticipants = 8
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimum = 0
        formatter.locale = Locale.current
        return formatter
    }()
    
    private var calculatedTip: Double {
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
    
    var calculationTotalBaseAmount: Int {
        participants.reduce(0) { $0 + $1.baseShares.reduce(0, +) }
    }
    
    var calculationTotalTipAmount: Int {
        var sum = 0
        for tips in participants {
            sum += tips.tipShares.reduce(0, +)
        }
        
        return sum
    }
    
    var calculationTotalAmount: Int {
        calculationTotalBaseAmount + calculationTotalTipAmount
    }
    
    var containsAmounts: Bool {
        participants.contains { !$0.baseShares.isEmpty }
    }
    
    init() {
        participants = (0..<minParticipants).map { _ in
            Participant()
        }
    }
    
    func addParticipant() {
        guard participants.count < maxParticipants else { return }
        participants.append(Participant())
    }
    
    func removeParticipant() {
        guard participants.count > minParticipants else { return }
        participants.removeLast()
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
    
    func addAmount() {
        guard let amount = Int(currentAmount), amount > 0 else { return }
        
        if selectedParticipantIndex == 0 {
            guard !participants.isEmpty else { return }
            
            let perPerson = Int(ceil(Double(amount) / Double(participants.count)))
            
            for i in 0..<participants.count {
                participants[i].baseShares.append(perPerson)
            }
        } else {
            let index = selectedParticipantIndex - 1
            if index < participants.count {
                participants[index].baseShares.append(amount)
            }
        }
        
        if isTipEnable {
            calculateTips()
        }
        
        currentAmount = ""
    }

    func calculateTips() {
        guard tipPercentage > 0 else {
            for i in participants.indices {
                participants[i].tipShares = Array(repeating: 0, count: participants[i].baseShares.count)
            }
            return
        }
        
        for i in participants.indices {
            participants[i].tipShares = participants[i].baseShares.map { base in
                let tip = Int(ceil(Double(base) * tipPercentage / 100.0))
                return tip
            }
        }
    }
    
    func resetToInitialState() {
        participants = (0..<minParticipants).map { _ in
            Participant()
        }
        
        tipPercentage = 15.0
        tipAmount = ""
        isTipEnable = false
    }
}
