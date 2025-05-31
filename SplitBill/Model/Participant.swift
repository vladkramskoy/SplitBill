//
//  Participant.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 22.05.2025.
//

import Foundation

struct Participant: Identifiable {
    
    let id = UUID()
    let individualShare: Double
    
    static func create() -> Participant {
        let participant = Participant(individualShare: 0.0)
        return participant
    }
}
