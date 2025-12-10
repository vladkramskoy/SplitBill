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
        ZStack {
            Color.SplitBill.backgroundLight
                .ignoresSafeArea()
            
            VStack {
                Picker("Выберите вкладку", selection: $selectedTab) {
                    Text("Поровну").tag(0)
                    Text("По блюдам").tag(1)
                    Text("По деньгам").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: selectedTab) { oldValue, newValue in
                    let method: SplitMethod
                    switch newValue  {
                    case 0: method = .equal
                    case 1: method = .itemized
                    case 2: method = .custom
                    default: method = .equal
                    }
                    AnalyticsService.logSplitMethodSelected(method)
                }
                
                TabView(selection: $selectedTab) {
                    EqualSplitView().tag(0)
                    
                    ItemizedSplitView(
                        showPopup: {
                            popupTitle = "Режим «По блюдам»"
                            popupMessage = "Разделение по съеденным блюдам"
                            popupIcon = "fork.knife"
                            isPopupPresented = true
                        }
                    ).tag(1)
                    
                    CustomSplitView(
                        showPopup: {
                            popupTitle = "Режим «По деньгам»"
                            popupMessage = "Разделение по суммам (кто сколько платит)"
                            popupIcon = "banknote"
                            isPopupPresented = true
                        }
                    ).tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .overlay {
                Group {
                    if isPopupPresented {
                        PopupView(isShowingPopup: $isPopupPresented, popupTitle: popupTitle, popupMessage: popupMessage, popupIcon: popupIcon)
                    }
                }
            }
            .navigationTitle("Как делить?")
            .onAppear {
                AnalyticsService.logScreen(name: "split_method_screen")
            }
        }
    }
}

#Preview {
    @Previewable @State var session = BillSession()
    
    SplitMethodView()
        .withRouter()
        .environment(session)
}
