//
//  HomeView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 21.05.2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Stepper (Participant Count)")
                NavigationLink("Next step", destination: TipPercentageView())
            }
            .navigationTitle("Участники")
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
