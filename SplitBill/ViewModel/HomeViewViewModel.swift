//
//  HomeViewViewModel.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 22.05.2025.
//

import Foundation

final class HomeViewViewModel: ObservableObject {
    @Published var participants: [Participant]
    
    let minParticipants = 2
    let maxParticipants = 8
    
    init() {
        self.participants = (0..<minParticipants).map { _ in
            Participant.create()
        }
    }
    
    func addParticipant() {
        guard participants.count < maxParticipants else { return }
        participants.append(Participant.create())
    }
    
    func removeParticipant() {
        guard participants.count > minParticipants else { return }
        participants.removeLast()
    }
}
