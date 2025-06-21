//
//  Participant.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 22.05.2025.
//

import Foundation

struct Participant: Identifiable {
    let id = UUID()
    var baseShares: [Int] = []
    var tipShare: Int = 0
    
    var total: Int {
        baseShares.reduce(0, +) + tipShare
    }
}
