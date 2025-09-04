//
//  ParticipantView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 21.05.2025.
//

import SwiftUI

struct ParticipantView: View {
    
    @Binding var path: NavigationPath
    @EnvironmentObject var data: SharedData
    
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
            
            Button(action: {
                path.append(Route.tipSelection)
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
    struct MockView: View {
        @State private var path = NavigationPath()
        
        var body: some View {
            ParticipantView(path: $path)
                .environmentObject(SharedData())
        }
    }
    return MockView()
}

