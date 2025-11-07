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
            
            floatingAddButton
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("По деньгам")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showPopup()
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .sheet(isPresented: $showInputModal) {
            inputModal
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
                    Text("Осталось")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(remaining.currencyFormatted)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(remaining > 0 ? .orange : .green)
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
                                colors: progress >= 1 ? [.green] : [.blue],
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
                    ParticipantRow(name: participant.name,
                                   amount: viewModel.amountFor(participantId: participant.id,
                                                               paymentShares: session.paymentSharesCustomMode))
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
                    viewModel.resetAll(from: &session.paymentSharesCustomMode)
                }
                .font(.subheadline)
                .foregroundStyle(Color.red)
            }
            
            if distributed == 0 {
                Text("Здесь будут отображаться последние операции")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(session.participants) { participant in
                        // TODO: process code
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
                                              paymentShares: &session.paymentSharesCustomMode)
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
                viewModel.resetAll(from: &session.paymentSharesCustomMode)
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
    
    // MARK: Back Button
    
    private var backButton: some View {
        Button {
            if hasDistributedAmounts {
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
                    router.popToRoot()
                }
            }
        } message: {
            Text("Все введенные данные будут потеряны")
        }
    }
    
    // MARK: - Floating Add Button

    private var floatingAddButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    viewModel.amountPaymentInput = ""
                    showInputModal = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Добавить")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .padding(.trailing, 16)
                .padding(.bottom, 16)
            }
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
                    viewModel.addPaymentShare(to: &session.paymentSharesCustomMode, for: session.participants)
                    showInputModal = false
                }
                .fontWeight(.semibold)
                .foregroundStyle(viewModel.amountPaymentInput.isEmpty ? .gray : .blue)
                .disabled(viewModel.amountPaymentInput.isEmpty)
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
            viewModel.selectedPersonIndex = index
        }) {
            VStack(spacing: 8) {
                Circle()
                    .fill(viewModel.selectedPersonIndex == index ? Color.blue : Color(.systemGray5))
                    .frame(width: 50, height: 50)
                    .overlay {
                        Text(String(session.participants[index].name.prefix(1)))
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(viewModel.selectedPersonIndex == index ? .white : .primary)
                    }
                
                Text(session.participants[index].name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(viewModel.selectedPersonIndex == index ? .blue : .primary)
                
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var distributed: Double {
        viewModel.distributedAmount(from: session.paymentSharesCustomMode)
    }
    
    private var remaining: Double {
        viewModel.remainingAmount(total: session.totalAmount, paymentShares: session.paymentSharesCustomMode)
    }
    
    private var progress: Double {
        viewModel.distributionProgress(total: session.totalAmount, paymentShares: session.paymentSharesCustomMode)
    }
    
    private var hasDistributedAmounts: Bool {
        !session.paymentSharesCustomMode.isEmpty
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
