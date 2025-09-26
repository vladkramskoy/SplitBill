//
//  ContentView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 14.09.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var sharedData = SharedData()
    
    var body: some View {
        ParticipantView()
            .withRouter()
            .environmentObject(sharedData)
    }
}

#Preview {
    ContentView()
}
