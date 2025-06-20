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
            
            Button("Далее") {
                path.append(Route.tipSelection)
            }
            .padding(.bottom, 125)
        }
        .navigationTitle("Участники")
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

