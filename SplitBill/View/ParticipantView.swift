//
//  ParticipantView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 21.05.2025.
//

import SwiftUI

struct ParticipantView: View {
    @EnvironmentObject private var sharedData: SharedData
    @Environment(Router.self) private var router
    
    let id = UUID()
    
    init() {
        print("\(Self.self) \(id)")
    }
    
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
                    sharedData.removeParticipant()
                }) {
                    Image(systemName: "minus.circle.fill")
                }
                .disabled(sharedData.participants.count <= sharedData.minParticipants)
                
                Text("Делим счёт на \(sharedData.participants.count) человек")
                
                Button(action: {
                    sharedData.addParticipant()
                }) {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(sharedData.participants.count >= sharedData.maxParticipants)
            }
            
            Spacer()
            
            Button(action: {
                router.navigateToBillAmount()
                print(id)
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
    
    ParticipantView()
        .environmentObject(sharedData)
        .withRouter()
}
