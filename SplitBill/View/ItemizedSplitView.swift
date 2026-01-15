//
//  ItemizedSplitView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 03.10.2025.
//

import SwiftUI

struct ItemizedSplitView: View {
    @Environment(Router.self) private var router
    @Environment(BillSession.self) private var session
    @StateObject private var viewModel = ItemizedSplitViewModel()
    @State private var showInputModal = false
    @State private var completionLoggedOnce = false
    
    private let tolerance: Double = 0.001
    
    private let emojiOptions = ["🍕", "🍝", "🥗", "🥩", "🍖", "🍗", "🍤", "🍣", "🍱", "🍜", "🍲", "🥘", "🍰", "🧁", "🍷", "🍺", "☕️", "🥤"]
    
    var body: some View {
        @Bindable var session = session
        
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    progressSection
                    participantSection

                    if session.receiptItems.isEmpty {
                        emptyItemsCard
                    } else {
                        itemsCardList(
                            receiptItems: $session.receiptItems,
                            participants: session.participants)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
                .padding(.bottom, 80)
            }
            
            AddButton(title: "Добавить блюдо", action: {
                viewModel.amountPaymentInput = ""
                viewModel.dishName = ""
                viewModel.quantity = 1
                showInputModal = true
            })
        }
        .sheet(isPresented: $showInputModal) {
            inputModal
                .presentationDetents([.height(380)])
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            AnalyticsService.logScreen(name: "itemized_split_screen")
        }
        .onChange(of: remaining) { oldValue, newValue in
            if !completionLoggedOnce && oldValue != 0 && newValue == 0 && !session.receiptItems.isEmpty {
                AnalyticsService.logBillSplitCompleted(
                    method: .itemized,
                    participants: session.participants.count,
                    items: session.receiptItems.count,
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
                        Image(systemName: hasRemainingAmount ? "chart.pie.fill" : isDistributionComplete ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(hasRemainingAmount ? .orange : isDistributionComplete ? .green : .red)
                        
                        Text(abs(remaining).currencyFormatted)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(hasRemainingAmount ? .orange : isDistributionComplete ? .green : .red)
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
                            isProgressComplete
                            ? LinearGradient(
                                colors:  (hasOverpayment ? [.red] : [.green]),
                                startPoint: .leading,
                                endPoint: .trailing)
                            : Color.SplitBill.blueCyanGradient
                        )
                        .frame(width: geometry.size.width * min(1, progress))
                }
            }
            .frame(height: 6)
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
            
            VStack(spacing: 12) {
                ForEach(session.participants) { participant in
                    let participantAmount = viewModel.amountFor(participantId: participant.id, receiptItems: session.receiptItems)
                    
                    let onShare = ShareService.formatForParticipant(participantName: participant.name, participantAmount: participantAmount, totalAmount: session.totalAmount)
                    
                    ParticipantRow(participant: participant,
                                    amount: participantAmount,
                                    onShare: { onShare })
                    .simultaneousGesture(TapGesture().onEnded {
                        AnalyticsService.logShareResult(
                            type: .participant,
                            method: .itemized
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
    
    // MARK: - Input Modal Window
    
    private var inputModal: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Отмена") {
                    showInputModal = false
                    viewModel.validationError = nil
                }
                .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("Новое блюдо")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Добавить") {
                    if viewModel.addDish(to: &session.receiptItems) {
                        viewModel.applyEqualSplitIfNeeded(
                            participants: session.participants,
                            receiptItems: &session.receiptItems
                        )
                        viewModel.emoji = "🍽️"
                        viewModel.splitEqually = false
                        showInputModal = false
                    }
                }
                .fontWeight(.semibold)
                .foregroundStyle(viewModel.amountPaymentInput.isEmpty ||
                                 viewModel.dishName.isEmpty ||
                                 viewModel.quantity < 1 ? .gray : .blue)
                .disabled(viewModel.amountPaymentInput.isEmpty ||
                          viewModel.dishName.isEmpty ||
                          viewModel.quantity < 1)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            Form {
                Section {
                    HStack {
                        Text("Эмодзи")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Menu {
                            ForEach(emojiOptions, id: \.self) { emojiOption in
                                Button(emojiOption) {
                                    viewModel.emoji = emojiOption
                                }
                            }
                        } label: {
                            Text(viewModel.emoji)
                                .font(.system(size: 32))
                        }
                    }
                    
                    TextField("Название", text: $viewModel.dishName)
                        .onChange(of: viewModel.dishName) { _, _ in
                            viewModel.validationError = nil
                        }
                    
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
                                viewModel.validationError = nil
                            }
                            
                        Text("₽")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    
                    Stepper("Количество: \(viewModel.quantity)", value: $viewModel.quantity, in: 1...99)
                        .onChange(of: viewModel.quantity) { oldValue, newValue in
                            viewModel.validationError = nil
                        }
                    
                    Toggle(isOn: $viewModel.splitEqually) {
                        Text("За это платят все")
                    }
                }
            }
            
            if let error = viewModel.validationError {
                VStack {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                            .font(.caption)
                        
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
    
    // MARK: - Items Section Header
    
    private var itemsSectionHeader: some View {
        HStack {
            Text("Позиции чека")
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Text("\(session.receiptItems.count) поз.")
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(session.receiptItems.isEmpty ? Color.gray.opacity(0.1) : Color.green.opacity(0.1))
                .foregroundStyle(session.receiptItems.isEmpty ? .gray : .green)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    // MARK: - Empty Items Card
    
    private var emptyItemsCard: some View {
        VStack {
            itemsSectionHeader
            
            EmptyStateView(
                icon: "fork.knife",
                title: "Нет позиций чека",
                description: "Добавьте блюда, чтобы начать распределение счёта",
                exampleText: "Добавьте все блюда из чека и отметьте, кто что ел",
                accentColor: .blue
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Items Card List
    
    @ViewBuilder
    private func itemsCardList(receiptItems: Binding<[BillItem]>, participants: [Participant]) -> some View {
        itemsSectionHeader
        
        VStack(spacing: 12) {
            ForEach(receiptItems) { $billItem in
                BillItemCard(item: $billItem,
                             participants: participants,
                             onSplitEqually: { viewModel.equalSplitPayers(
                                for: &billItem,
                                participants: session.participants) },
                             onReset: { viewModel.resetPayers(for: &billItem) },
                             onDelete: { viewModel.deleteItemCard(for: billItem, from: &session.receiptItems) }
                )
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
        }
    }
    
    // MARK: - Computed Properties

    private var distributed: Double {
        viewModel.distributedAmount(from: session.receiptItems)
    }
    
    private var remaining: Double {
        viewModel.remainingAmount(total: session.totalAmount, items: session.receiptItems)
    }
    
    private var progress: Double {
        viewModel.distributionProgress(total: session.totalAmount, items: session.receiptItems)
    }
    
    private var isDistributionComplete: Bool {
        abs(remaining) <= tolerance
    }
    
    private var hasRemainingAmount: Bool {
        remaining > tolerance
    }
    
    private var hasOverpayment: Bool {
        remaining < -tolerance
    }
    
    private var isProgressComplete: Bool {
        progress > (1.0 - tolerance)
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var session = BillSession()
    
    session.participants = [
        Participant(name: "Оля", color: Color.SplitBill.adaptiveParticipant1),
        Participant(name: "Маша", color: Color.SplitBill.adaptiveParticipant2),
        Participant(name: "Даша", color: Color.SplitBill.adaptiveParticipant3)
    ]
    
    let billUnits: [BillUnit] = [
        BillUnit(id: UUID(), payers: [session.participants[0].id, session.participants[1].id, session.participants[2].id])
    ]
    
    session.receiptItems = [
        BillItem(id: UUID(), name: "Стейк", quantity: 3, pricePerUnit: 500, units: billUnits),
        BillItem(id: UUID(), name: "Вино", quantity: 2, pricePerUnit: 800, units: billUnits)
    ]
    
    session.totalAmount = 5000
    
    return NavigationStack() {
        ItemizedSplitView()
            .environment(session)
            .withRouter()
    }
}
