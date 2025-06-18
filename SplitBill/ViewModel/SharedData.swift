//
//  SharedData.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 22.05.2025.
//

import Foundation

final class SharedData: ObservableObject {
    
    @Published var participants: [Participant]
    @Published var tipPercentage: Double = 10
    
    let minParticipants = 2
    let maxParticipants = 8
    
    init() {
        self.participants = (0..<minParticipants).map { _ in
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
}
