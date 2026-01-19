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
    @Published var validationError: String? = nil
    
    var canProceed: Bool {
        participants.count >= 2
    }
    
    func addParticipant(for name: String) {
        let nameValidation = ValidationService.validateParticipantName(name)
        guard nameValidation.isValid else {
            validationError = nameValidation.errorMessage
            return
        }
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let colorIndex = participants.count
        let color = Color.SplitBill.participantColor(at: colorIndex)
        let newParticipant = Participant(name: trimmedName, color: color)
        
        let participantsValidation = ValidationService.validateParticipants(participants + [newParticipant])
        guard participantsValidation.isValid else {
            validationError = participantsValidation.errorMessage
            return
        }
        
        participants.append(newParticipant)
        nameInput = ""
        validationError = nil
        
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
        
        validationError = nil
        AnalyticsService.logParticipantRemoved(total: participants.count)
    }
}
