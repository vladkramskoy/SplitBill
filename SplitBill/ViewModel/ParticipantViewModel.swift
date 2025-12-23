//
//  ParticipantViewModel.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 29.10.2025.
//

import SwiftUI

final class ParticipantViewModel: ObservableObject {
    @Published var participants: [Participant] = []
    @Published var nameInput: String = ""
    
    var canProceed: Bool {
        participants.count >= 2
    }
    
    func addParticipant(for name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let colorIndex = participants.count
        let color = Color.SplitBill.participantColor(at: colorIndex)
        
        participants.append(Participant(name: trimmedName, color: color))
        nameInput = ""
        
        AnalyticsService.logParticipantAdded(total: participants.count)
    }
    
    func removeParticipant(at offsets: IndexSet) {
        participants.remove(atOffsets: offsets)
        
        for (index, participant) in participants.enumerated() {
            participants[index] = Participant(
                name: participant.name,
                color: Color.SplitBill.participantColor(at: index)
            )
        }
        
        AnalyticsService.logParticipantRemoved(total: participants.count)
    }
}
