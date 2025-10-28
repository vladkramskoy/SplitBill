//
//  SharedData.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 22.05.2025.
//

import Foundation

final class SharedData: ObservableObject {

    // MARK: - Properties
    
    @Published var participants: [Participant] = []
    @Published var billAmount = ""
    @Published var tipCalculationType: TipCalculationType = .percentage
    @Published var tipPercentage = 15.0
    @Published var tipAmount = ""
    @Published var isTipEnable = false
    @Published var nameInput: String = ""
    
    // TODO: move to CustomSplit viewModel
    @Published var amountPaymentInput = ""
    @Published var selectedPersonIndex = 0
    
    var destributedAmount: Double {
        var amount = 0.0
        
        for i in participants {
            amount += i.mustPayAll
        }
        
        return amount
    }
    
    var remainingAmount: Double {
        amountWithTips - destributedAmount
    }
    
    var progressForDestributedAmount: Double {
        destributedAmount / amountWithTips
    }
    
    private var formatter: DecimalFormatting
    
    init(formatter: DecimalFormatting = DecimalFormatter()) {
        self.formatter = formatter
    }
    
    // MARK: - Computed Properties
    
    var billAmountConvertInDouble: Double {
        guard let amount = formatter.parse(billAmount) else { return 0 }
        return amount
    }
    
    var destributedAmountInString: String {
        formatter.format(destributedAmount)
    }
    
    var remainingAmountInString: String {
        formatter.format(remainingAmount)
    }
    
    var calculatedTip: Double {
        guard isTipEnable else { return 0 }
        
        if tipCalculationType == .percentage {
            guard let amount = formatter.parse(billAmount) else { return 0 }
            
            return amount * tipPercentage / 100
        } else {
            guard let tipAmount = formatter.parse(tipAmount) else { return 0 }
            return tipAmount
        }
    }
    
    var amountWithTips: Double {
        guard let amount = formatter.parse(billAmount) else { return 0 }
        return amount + calculatedTip
    }
    
    var isValidAmount: Bool {
        if billAmount.isEmpty {
            return false
        }
        guard let number = formatter.parse(billAmount) else { return false }
        return number >= 10
    }
    
    var amountPerPerson: Double {
        guard !participants.isEmpty else { return 0 }
        return amountWithTips / Double(participants.count)
    }
    
    // TODO: process refactor
    
//    var containsAmounts: Bool {
//        participants.contains { !$0.baseShares.isEmpty }
//    }
    
    // MARK: - Methods
    
    func addParticipant(for name: String) {
        let participant = Participant(name: name)
        participants.append(participant)
        nameInput = ""
    }
    
    func removeParticipant(at offsets: IndexSet) {
        participants.remove(atOffsets: offsets)
    }
    
    func addPaymentSharesForCustomSplit() {
        guard let share = formatter.parse(amountPaymentInput) else { return }
        
        for i in 0..<participants.count {
            
            if i == selectedPersonIndex {
                participants[i].paymentShares.append(share)
                print("\(participants[i].name) получил долю \(share), всего должен \(participants[i].mustPayAll)")
            }
        }
    }
    
    func resetToInitialState() {
        participants = []
        billAmount = ""
        tipPercentage = 15.0
        tipAmount = ""
        isTipEnable = false
    }
}
