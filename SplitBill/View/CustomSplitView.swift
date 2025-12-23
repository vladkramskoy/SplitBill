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
    @State private var showInputModal = false
    @FocusState private var isTextFieldFocused: Bool
    @State private var completionLoggedOnce = false
    
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
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(distributed.currencyFormatted)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                    
                    Text("Распределено")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: remaining > 0 ? "chart.pie.fill" : remaining == 0 ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(remaining > 0 ? .orange : remaining == 0 ? .green : .red)
                        
                        Text(abs(remaining).currencyFormatted)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(remaining > 0 ? .orange : remaining == 0 ? .green : .red)
                    }
                    
                    Text(remaining >= 0 ? "Осталось" : "Перебор")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(16)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray6))
                    
                    Capsule()
                        .fill(
                            progress >= 1
                            ? LinearGradient(
                                colors:  (remaining < 0 ? [.red] : [.green]),
                                startPoint: .leading,
                                endPoint: .trailing)
                            : Color.SplitBill.primaryGradient
                        )
                        .frame(width: geometry.size.width * min(1, progress))
                }
            }
            .frame(height: 6)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
            quickActions
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
        }
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
                            method: .custom
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
                EmptyStateView(
                    icon: "banknote",
                    title: "Нет долей оплаты",
                    description: "Добавьте первую долю, чтобы начать распределение счёта",
                    exampleText: "Например: Макс платит 800₽, остальное делим поровну",
                    accentColor: .blue
                )
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
    
    // MARK: Quick Action
    
    private var quickActions: some View {
        HStack(spacing: 8) {
            Menu {
                Button {
                    viewModel.distributeRemaining(
                        total: session.totalAmount,
                        participants: session.participants,
                        paymentShares: &session.customPaymentShares)
                    
                    AnalyticsService.logDistributeRemaining(
                        participants: session.participants.count,
                        totalAmount: session.totalAmount)
                } label: {
                    Label("Поровну между всеми", systemImage: "equal.circle")
                }
                
                Button {
                    viewModel.distributeRemainingToUnassigned(
                        total: session.totalAmount,
                        participants: session.participants,
                        paymentShares: &session.customPaymentShares)
                    
                    AnalyticsService.logDistributeRemainingToUnassigned(
                        participants: session.participants.count,
                        totalAmount: session.totalAmount)
                } label: {
                    Label("На участников без долей", systemImage: "person.2.circle")
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "square.split.2x1")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Распределить остаток")
                        .font(.caption)
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .semibold))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .background(Color.blue.opacity(0.1))
                .foregroundStyle(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(session.customPaymentShares.isEmpty || remaining <= 0)
            .opacity(session.customPaymentShares.isEmpty || remaining <= 0 ? 0.5 : 1)
            
            Button(action: {
                viewModel.resetAll(from: &session.customPaymentShares)
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .medium))
                    Text("Сбросить")
                        .font(.caption)
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .background(Color.red.opacity(0.1))
                .foregroundStyle(.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(distributed == 0)
            .opacity(distributed == 0 ? 0.5 : 1)
        }
        .fixedSize(horizontal: false, vertical: true)
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
        CustomSplitView()
            .environment(session)
            .withRouter()
    }
}
