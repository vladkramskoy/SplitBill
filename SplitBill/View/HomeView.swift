//
//  HomeView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 21.05.2025.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                HStack {
                    Button(action: {
                        viewModel.removeParticipant()
                    }) {
                        Image(systemName: "minus.circle.fill")
                    }
                    .disabled(viewModel.participants.count <= viewModel.minParticipants)
                    
                    Text("Делим счёт на \(viewModel.participants.count) человек")
                    
                    Button(action: {
                        viewModel.addParticipant()
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(viewModel.participants.count >= viewModel.maxParticipants)
                }
                Spacer()
                
                NavigationLink("Далее", destination: TipPercentageView())
                    .padding(.bottom, 125)
            }
            .navigationTitle("Участники")
        }
    }
}

#Preview {
    HomeView()
}
