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

            Button(action: {
                path.append(Route.tipSelection)
            }) {
                Text("Далее")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .padding()
        }
        .navigationTitle("Шаг 1 из 3")
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

