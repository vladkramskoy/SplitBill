//
//  SplitMethodView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 03.10.2025.
//

import SwiftUI

struct SplitMethodView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            Picker("Выберите вкладку", selection: $selectedTab) {
                Text("Поровну").tag(0)
                Text("По блюдам").tag(1)
                Text("По деньгам").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()
            
            TabView(selection: $selectedTab) {
                EqualSplitView().tag(0)
                ItemizedSplitView().tag(1)
                CustomSplitView().tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationTitle("Как делить?")
    }
}

#Preview {
    SplitMethodView()
}
