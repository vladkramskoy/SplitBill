//
//  SplitMethodView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 03.10.2025.
//

import SwiftUI

struct SplitMethodView: View {
    @State private var selectedTab = 0
    @State private var isPopupPresented = false
    @State private var popupTitle = ""
    @State private var popupMessage = ""
    @State private var popupIcon = ""
    
    var body: some View {
        VStack {
            Picker("Выберите вкладку", selection: $selectedTab) {
                Text("Поровну").tag(0)
                Text("По блюдам").tag(1)
                Text("По деньгам").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 16)
            
            TabView(selection: $selectedTab) {
                EqualSplitView().tag(0)
                ItemizedSplitView().tag(1)
                CustomSplitView(
                    showPopup: {
                        popupTitle = "Режим «Вручную»"
                        popupMessage = "Суммы вносятся произвольно. Например: первый участник платит за алкоголь, второй за еду."
                        popupIcon = "slider.horizontal.3"
                        isPopupPresented = true
                    }
                ).tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .overlay {
            Group {
                if isPopupPresented {
                    PopupView(isShowingPopup: $isPopupPresented, popupTitle: popupTitle, popupMessage: popupMessage, popupIcon: popupIcon)
                }
            }
        }
        .navigationTitle("Как делить?")
    }
}

#Preview {
    @Previewable @State var session = BillSession()
    
    SplitMethodView()
        .withRouter()
        .environment(session)
}
