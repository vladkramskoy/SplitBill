//
//  Participant.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 22.05.2025.
//

import Foundation

struct Participant: Identifiable {
    let id = UUID()
    let name: String
    var baseShares: [Int] = []
    var tipShares: [Int] = []
    
    var total: Int {
        baseShares.reduce(0, +) + tipShares.reduce(0, +)
    }
}
