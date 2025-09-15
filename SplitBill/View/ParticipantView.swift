//
//  ParticipantView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 21.05.2025.
//

import SwiftUI

struct ParticipantView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    @ObservedObject var participantViewModel: ParticipantViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("Раздели счет!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Выберите количество участников")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            HStack {
                Button(action: {
                    participantViewModel.removeParticipant()
                }) {
                    Image(systemName: "minus.circle.fill")
                }
                .disabled(participantViewModel.shareData.participants.count <= participantViewModel.minParticipants)
                
                Text("Делим счёт на \(participantViewModel.shareData.participants.count) человек")
                
                Button(action: {
                    participantViewModel.addParticipant()
                }) {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(participantViewModel.shareData.participants.count >= participantViewModel.maxParticipants)
            }
            
            Spacer()
            
            Button(action: {
                coordinator.push(Route.tipSelection)
            }) {
                Text("Начать")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Главная")
        .toolbar(.hidden)
    }
}

#Preview {
    @Previewable @StateObject var sharedData = SharedData()
    @Previewable @StateObject var coordinator = Coordinator()
    
    ParticipantView(participantViewModel: ParticipantViewModel(sharedData: sharedData))
        .environmentObject(sharedData)
        .environmentObject(coordinator)
}
