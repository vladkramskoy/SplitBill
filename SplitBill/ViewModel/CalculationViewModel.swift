//
//  CalculationViewModel.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 15.09.2025.
//

import Foundation

final class CalculationViewModel: ObservableObject {
    
    @Published var currentAmount: String = ""
    @Published var selectedParticipantIndex = 0
    
    var shareData: SharedData
    
    init(sharedData: SharedData) {
        self.shareData = sharedData
    }
    
    func addAmount() {
        guard let amount = Int(currentAmount), amount > 0 else { return }
        
        if selectedParticipantIndex == 0 {
            guard !shareData.participants.isEmpty else { return }
            
            let perPerson = Int(ceil(Double(amount) / Double(shareData.participants.count)))
            
            for i in 0..<shareData.participants.count {
                shareData.participants[i].baseShares.append(perPerson)
            }
        } else {
            let index = selectedParticipantIndex - 1
            if index < shareData.participants.count {
                shareData.participants[index].baseShares.append(amount)
            }
        }
        
        if shareData.isTipEnable {
            calculateTips()
        }
        
        currentAmount = ""
    }

    func calculateTips() {
        guard shareData.tipPercentage > 0 else {
            for i in shareData.participants.indices {
                shareData.participants[i].tipShares = Array(repeating: 0, count: shareData.participants[i].baseShares.count)
            }
            return
        }
        
        for i in shareData.participants.indices {
            shareData.participants[i].tipShares = shareData.participants[i].baseShares.map { base in
                let tip = Int(ceil(Double(base) * shareData.tipPercentage / 100.0))
                return tip
            }
        }
    }
}
