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
        !participants.isEmpty
    }
    
    func addParticipant(for name: String) {
        let participant = Participant(name: name)
        participants.append(participant)
        nameInput = ""
    }
    
    func removeParticipant(at offsets: IndexSet) {
        participants.remove(atOffsets: offsets)
    }
}
