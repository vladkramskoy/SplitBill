//
//  ParticipantViewModel.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 14.09.2025.
//

import Foundation

final class ParticipantViewModel: ObservableObject {
    let shareData: SharedData
    
    let minParticipants = 2
    let maxParticipants = 8
    
    init(sharedData: SharedData) {
        self.shareData = sharedData
    }
    
    func addParticipant() {
        guard shareData.participants.count < maxParticipants else { return }
        shareData.participants.append(Participant())
    }
    
    func removeParticipant() {
        guard shareData.participants.count > minParticipants else { return }
        shareData.participants.removeLast()
    }
}
