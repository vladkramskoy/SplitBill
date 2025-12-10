//
//  ParticipantViewModel.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 29.10.2025.
//

import Foundation

final class ParticipantViewModel: ObservableObject {
    @Published var participants: [Participant] = []
    @Published var nameInput: String = ""
    
    var canProceed: Bool {
        participants.count >= 2
    }
    
    func addParticipant(for name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        participants.append(Participant(name: trimmedName))
        nameInput = ""
        
        AnalyticsService.logParticipantAdded(total: participants.count)
    }
    
    func removeParticipant(at offsets: IndexSet) {
        participants.remove(atOffsets: offsets)
        
        AnalyticsService.logParticipantRemoved(total: participants.count)
    }
}
