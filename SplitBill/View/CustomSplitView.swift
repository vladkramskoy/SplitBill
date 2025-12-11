//
//  CustomSplitView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 31.05.2025.
//

import SwiftUI

struct CustomSplitView: View {
    @Environment(Router.self) private var router
    @Environment(BillSession.self) private var session
    @StateObject private var viewModel = CustomSplitViewModel()
    @State private var showAlert = false
    @State private var showInputModal = false
    @FocusState private var isTextFieldFocused: Bool
    @State private var completionLoggedOnce = false
    
    var showPopup: () -> Void
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    progressSection
                    participantSection
                    recentTransactionsSection
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
                .padding(.bottom, 80)
            }
            
            AddButton(title: "Добавить долю", action: {
                viewModel.amountPaymentInput = ""
                viewModel.selectedPersonIndices = []
                showInputModal = true
            })
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton(
                    screenName: "custom_split_screen",
                    onReset: {},
                    showAlert: $showAlert,
                    router: router,
                    session: session,
                    billDataProcess: billDataProcess)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    AnalyticsService.logOnboardingOpened(source: "helpButton")
                    showPopup()
                } label: {
                    Image(systemName: "info.circle")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: viewModel.shareResult(totalAmount: session.totalAmount, participants: session.participants, paymentShares: session.customPaymentShares)) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                .simultaneousGesture(TapGesture().onEnded {
                    AnalyticsService.logShareResult(
                        type: .fullBill,
                        method: .custom,
                        isFullyDistributed: remaining == 0 ? true : false
                    )
                })
            }
        }
        .sheet(isPresented: $showInputModal) {
            inputModal
        }
        .onAppear {
            AnalyticsService.logScreen(name: "custom_split_screen")
        }
        .onChange(of: remaining) { oldValue, newValue in
            if !completionLoggedOnce && oldValue != 0 && newValue == 0 && !session.customPaymentShares.isEmpty {
                AnalyticsService.logBillSplitCompleted(
                    method: .custom,
                    participants: session.participants.count,
                    items: session.customPaymentShares.count,
                    totalAmount: session.totalAmount,
                    durationSec: session.getSessionDuration(),
                    success: true
                )
                completionLoggedOnce = true
            }
        }
    }
    
    // MARK: - Progress Section
    
    private var progressSection: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Распределено")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(distributed.currencyFormatted)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(remaining >= 0 ? "Осталось" : "Перебор")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(abs(remaining).currencyFormatted)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(remaining > 0 ? .orange : remaining == 0 ? .green : .red)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 4)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: progress >= 1 ? (remaining < 0 ? [.red] : [.green]) : [.blue],
                                startPoint: .leading,
                                endPoint: .trailing)
                        )
                        .frame(width: geometry.size.width * min(1, progress), height: 4)
                }
            }
            .frame(height: 4)
            
            quickActionButtons
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Participants Section
    
    private var participantSection: some View {
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
                    let participantAmount = viewModel.amountFor(participantId: participant.id, paymentShares: session.customPaymentShares)
                    
                    let onShare = { ShareService.formatForParticipant(participantName: participant.name, participantAmount: participantAmount, totalAmount: session.totalAmount) }
                    
                    ParticipantRow(name: participant.name,
                                   amount: participantAmount, onShare: onShare)
                    .simultaneousGesture(TapGesture().onEnded {
                        AnalyticsService.logShareResult(
                            type: .participant,
                            method: .custom,
                            isFullyDistributed: remaining == 0 ? true : false
                        )
                    })
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: Recent Transactions Section
    
    private var recentTransactionsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Последние операции")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Очистить") {
                    viewModel.resetAll(from: &session.customPaymentShares)
                }
                .font(.subheadline)
                .foregroundStyle(distributed == 0 ? .gray : .red)
                .disabled(distributed == 0)
            }
            
            if distributed == 0 {
                HStack(spacing: 12) {
                    Image(systemName: "banknote")
                        .font(.system(size: 36))
                        .foregroundStyle(.tertiary)
                    
                    VStack(spacing: 4) {
                        Text("Нет долей оплаты")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        Text("Добавьте первую, чтобы начать распределение")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
                .padding(.vertical, 28)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(session.customPaymentShares, id: \.id) { share in
                        ParticipantRow(name: share.name, amount: share.amount, onShare: nil)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: Quick Action Buttons
    
    private var quickActionButtons: some View {
        HStack(spacing: 12) {
            Button(action: {
                viewModel.distributeRemaining(total: session.totalAmount,
                                              participants: session.participants,
                                              paymentShares: &session.customPaymentShares)
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "equal.circle")
                        .font(.system(size: 14, weight: .medium))
                    Text("Распределить остаток")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Button(action: {
                viewModel.resetAll(from: &session.customPaymentShares)
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 14, weight: .medium))
                    Text("Сбросить")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.1))
                .foregroundStyle(.red)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Spacer()
        }
    }
    
    // MARK: - Input Modal Window
    
    private var inputModal: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Отмена") {
                    showInputModal = false
                }
                .foregroundStyle(.secondary)
                
                Spacer()
             
                Text("Новый платеж")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Готово") {
                    viewModel.addPaymentShare(to: &session.customPaymentShares, for: session.participants)
                    showInputModal = false
                }
                .fontWeight(.semibold)
                .foregroundStyle(viewModel.amountPaymentInput.isEmpty ||
                                 viewModel.selectedPersonIndices.isEmpty ? .gray : .blue)
                .disabled(viewModel.amountPaymentInput.isEmpty ||
                          viewModel.selectedPersonIndices.isEmpty)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            Divider()
            
            VStack(spacing: 20) {
                
                VStack(spacing: 8) {
                    Text("Сумма")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        TextField("0", text: $viewModel.amountPaymentInput)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 28, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .onChange(of: viewModel.amountPaymentInput) { oldValue, newValue in
                                let formatted = InputValidator.formatCurrencyInput(newValue)
                                if formatted != newValue {
                                    viewModel.amountPaymentInput = formatted
                                }
                            }
                            
                        Text("₽")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 8)
                
                VStack(spacing: 8) {
                    Text("Кто платит")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<session.participants.count, id: \.self) { index in
                                personButton(for: index)
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            Spacer()
        }
        .presentationDetents([.height(280)])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: Person Button
    
    private func personButton(for index: Int) -> some View {
        Button(action: {
            viewModel.togglePersonSelection(at: index)
        }) {
            VStack(spacing: 8) {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(viewModel.selectedPersonIndices.contains(index) ? Color.blue : Color(.systemGray5))
                        .frame(width: 50, height: 50)
                        .overlay {
                            Text(String(session.participants[index].name.prefix(1)))
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(viewModel.selectedPersonIndices.contains(index) ? .white : .primary)
                        }
                    
                    if viewModel.selectedPersonIndices.contains(index) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.white)
                            .background(Circle().fill(Color.green))
                            .font(.system(size: 14))
                            .offset(x: 4, y: 4)
                    }
                }
                
                Text(session.participants[index].name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(viewModel.selectedPersonIndices.contains(index) ? .blue : .primary)
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var distributed: Double {
        viewModel.distributedAmount(from: session.customPaymentShares)
    }
    
    private var remaining: Double {
        viewModel.remainingAmount(total: session.totalAmount, paymentShares: session.customPaymentShares)
    }
    
    private var progress: Double {
        viewModel.distributionProgress(total: session.totalAmount, paymentShares: session.customPaymentShares)
    }
    
    private var billDataProcess: Bool {
        !session.receiptItems.isEmpty ||
        !session.customPaymentShares.isEmpty
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
    session.totalAmount = 5000
    
    return NavigationStack {
        CustomSplitView(showPopup: {})
            .environment(session)
            .withRouter()
    }
}
