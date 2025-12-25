//
//  SplitMethodView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 03.10.2025.
//

import SwiftUI

struct SplitMethodView: View {
    @Environment(Router.self) private var router
    @Environment(BillSession.self) private var session
    @State private var selectedTab = 0
    @State private var isPopupPresented = false
    @State private var popupTitle = ""
    @State private var popupMessage = ""
    @State private var popupIcon = ""
    @State private var showAlert = false
    @State private var showItemizedOnboarding = false
    
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
                    ItemizedSplitView().tag(1)
                    CustomSplitView().tag(2)
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
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton(
                    screenName: screenNameForCurrentTab,
                    onReset: {},
                    showAlert: $showAlert,
                    router: router,
                    session: session,
                    billDataProcess: billDataProcess)
            }
            
            if selectedTab == 1 || selectedTab == 2 {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        AnalyticsService.logOnboardingOpened(source: "helpButton")
                        showHelpForCurrentTab()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: shareTextForCurrentTab) {
                    Image(systemName: "square.and.arrow.up")
                }
                .simultaneousGesture(TapGesture().onEnded {
                    logShareForCurrentTab()
                })
            }
        }
        .onAppear {
            AnalyticsService.logScreen(name: "split_method_screen")
        }
        .sheet(isPresented: $showItemizedOnboarding) {
            ItemizedSplitOnboardingView()
        }
    }
    
    private var screenNameForCurrentTab: String {
        switch selectedTab {
        case 0: return "equal_split_screen"
        case 1: return "itemized_split_screen"
        case 2: return "custom_split_screen"
        default: return "split_method_screen"
        }
    }
    
    private var billDataProcess: Bool {
        !session.receiptItems.isEmpty ||
        !session.customPaymentShares.isEmpty
    }
    
    private var shareTextForCurrentTab: String {
        switch selectedTab {
        case 0:
            return session.shareEqualResult()
        case 1:
            return session.shareItemizedResult()
        case 2:
            return session.shareCustomResult()
        default:
            return ""
        }
    }
    
    private func showHelpForCurrentTab() {
        switch selectedTab {
        case 1:
            showItemizedOnboarding = true
        default:
            popupTitle = "Режим «По деньгам»"
            popupMessage = "Разделение по суммам (кто сколько платит)"
            popupIcon = "banknote"
            isPopupPresented = true
        }
    }
    
    private func logShareForCurrentTab() {
        let method: SplitMethod
        
        switch selectedTab {
        case 0: method = .equal
        case 1: method = .itemized
        case 2: method = .custom
        default: method = .equal
        }
        
        AnalyticsService.logShareResult(
            type: .fullBill,
            method: method
        )
    }
}

#Preview {
    @Previewable @State var session = BillSession()
    
    SplitMethodView()
        .withRouter()
        .environment(session)
}
