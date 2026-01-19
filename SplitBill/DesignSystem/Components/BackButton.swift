//
//  BackButton.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 11.12.2025.
//

import SwiftUI

struct BackButton: View {
    let screenName: String
    let onReset: () -> Void
    @Binding var showAlert: Bool
    let router: Router
    let session: BillSession
    let billDataProcess: Bool
    
    var body: some View {
        Button {
            if billDataProcess {
                AnalyticsService.logBackAttemptWithUnsavedData(screen: screenName)
                showAlert = true
            } else {
                router.pop()
            }
        } label: {
            Image(systemName: "chevron.backward")
        }
        .alert("Вернуться?", isPresented: $showAlert) {
            Button("Отмена", role: .cancel) {}
            Button("Сбросить чеки", role: .destructive) {
                withAnimation {
                    session.reset()
                    AnalyticsService.logCalculationCancelled(screen: screenName)
                    router.popToRoot()
                    onReset()
                }
            }
        } message: {
            Text("Все введенные данные будут потеряны")
                .multilineTextAlignment(.center)
        }
    }
}
