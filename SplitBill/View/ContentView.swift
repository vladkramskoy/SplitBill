//
//  ContentView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 14.09.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var session = BillSession()
    
    var body: some View {
        ParticipantView()
            .withRouter()
            .environment(session)
    }
}

#Preview {
    ContentView()
}
