//
//  ParticipantView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 21.05.2025.
//

import SwiftUI

struct ParticipantView: View {
    
    @EnvironmentObject var data: SharedData
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                HStack {
                    Button(action: {
                        data.removeParticipant()
                    }) {
                        Image(systemName: "minus.circle.fill")
                    }
                    .disabled(data.participants.count <= data.minParticipants)
                    
                    Text("Делим счёт на \(data.participants.count) человек")
                    
                    Button(action: {
                        data.addParticipant()
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(data.participants.count >= data.maxParticipants)
                }
                Spacer()
                
                NavigationLink("Далее", destination: TipSelectionView())
                    .padding(.bottom, 125)
            }
            .navigationTitle("Участники")
        }
    }
}

#Preview {
    let sharedData = SharedData()
    
    ParticipantView()
        .environmentObject(sharedData)
}
