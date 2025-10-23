//
//  ContentView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 21.05.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showSupport = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                
                Spacer()
                    .frame(height: 30)
                
                Button(action: {
                    showSupport = true
                }) {
                    HStack {
                        Image(systemName: "questionmark.circle.fill")
                        Text("Support & Help")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("SplitBill")
            .sheet(isPresented: $showSupport) {
                SupportView()
            }
        }
    }
}

#Preview {
    ContentView()
}
