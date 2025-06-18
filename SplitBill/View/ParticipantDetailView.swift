//
//  ParticipantDetailView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 16.06.2025.
//

import SwiftUI

struct ParticipantDetailView: View {
    
    @Binding var participant: Participant
    var dismiss: () -> Void
    
    var body: some View {
        List {
            ForEach(participant.share, id: \.self) { amount in
                Text("\(amount) ₽")
            }
        }
        .navigationTitle("Счет участника")
        .toolbar { Button("Готово")
            { dismiss() }
        }
    }
}

#Preview {
    ParticipantDetailView(participant: .constant(Participant(share: [100])), dismiss: {})
}
