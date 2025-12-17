//
//  EqualSplitView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 03.10.2025.
//

import SwiftUI

struct EqualSplitView: View {
    @Environment(Router.self) private var router
    @Environment(BillSession.self) private var session
    @State private var showAlert = false
    @State private var completionLoggedOnce = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 20) {                        
                        VStack(spacing: 16) {
                            HStack {
                                Text("На человека:")
                                Spacer()
                                Text("₽\(session.equalAmountPerPerson(), specifier: "%.2f")")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.blue)
                            }
                            
                            HStack {
                                Text("Всего участников")
                                Spacer()
                                Text("\(session.participants.count)")
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Детали счета")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            DetailRow(title: "Сумма счета", value: session.billAmount, isTotal: false)
                            DetailRow(title: "Чаевые", value: session.tipAmount, isTotal: false)
                            Divider()
                            DetailRow(title: "Итого к оплате", value: session.totalAmount, isTotal: true)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Участники")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text("\(session.participants.count) чел.")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundStyle(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        LazyVStack(spacing: 12) {
                            ForEach(session.participants) { participant in
                                let onShare = { ShareService.formatForParticipant(participantName: participant.name, participantAmount: session.equalAmountPerPerson(), totalAmount: session.totalAmount) }
                                
                                ParticipantRow(name: participant.name,
                                               amount: session.equalAmountPerPerson(), onShare: onShare)
                                .simultaneousGesture(TapGesture().onEnded {
                                    if !completionLoggedOnce {
                                        AnalyticsService.logBillSplitCompleted(
                                            method: .equal,
                                            participants: session.participants.count,
                                            items: 0,
                                            totalAmount: session.totalAmount,
                                            durationSec: session.getSessionDuration(),
                                            success: true
                                        )
                                        completionLoggedOnce = true
                                    }
                                    
                                    AnalyticsService.logShareResult(
                                        type: .participant,
                                        method: .equal,
                                        isFullyDistributed: true
                                    )
                                })
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    
                    VStack(spacing: 12) {                        
                        Button("Новый расчет") {
                            session.reset()
                            AnalyticsService.logNewCalculation()
                            router.popToRoot()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton(
                    screenName: "equal_split_screen",
                    onReset: {},
                    showAlert: $showAlert,
                    router: router,
                    session: session,
                    billDataProcess: billDataProcess)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: shareResult()) {
                    Image(systemName: "square.and.arrow.up")
                }
                .simultaneousGesture(TapGesture().onEnded {
                    if !completionLoggedOnce {
                        AnalyticsService.logBillSplitCompleted(
                            method: .equal,
                            participants: session.participants.count,
                            items: 0,
                            totalAmount: session.totalAmount,
                            durationSec: session.getSessionDuration(),
                            success: true
                        )
                        completionLoggedOnce = true
                    }
                    AnalyticsService.logShareResult(type: .fullBill, method: .equal, isFullyDistributed: true)
                })
            }
        }
        .onAppear {
            AnalyticsService.logScreen(name: "equal_split_result")
        }
    }
    
    private var billDataProcess: Bool {
        !session.receiptItems.isEmpty ||
        !session.customPaymentShares.isEmpty
    }
    
    private func shareResult() -> String {
        let amounts: [UUID : Double] = session.participants.reduce(into: [:]) { dict, participant in
            dict[participant.id] = session.equalAmountPerPerson()
        }
        
        let shareText = ShareService.formatFullBill(totalAmount: session.billAmount, distributedAmount: session.billAmount, participants: session.participants, participantAmount: amounts)
        
        return shareText
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var session = BillSession()
    session.participants = [
        Participant(name: "Оля"),
        Participant(name: "Маша"),
        Participant(name: "Даша")
    ]
    
    return EqualSplitView()
        .environment(session)
        .withRouter()
}
