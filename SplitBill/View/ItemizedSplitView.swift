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
    
    var body: some View {
        @Bindable var session = session
        
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    progressSection
                    participantSection
                    billItemsSection(receiptItems: $session.receiptItems, participants: session.participants)
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
                    let participantAmount = viewModel.amountFor(participantId: participant.id, receiptItems: session.receiptItems)
                    
                    let onShare = ShareService.formatForParticipant(participantName: participant.name, participantAmount: participantAmount, totalAmount: session.totalAmount)
                    
                    ParticipantRow(name: participant.name,
                                   amount: participantAmount, onShare: { onShare })
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
                }
                .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("Новое блюдо")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Добавить") {
                    viewModel.addDish(to: &session.receiptItems)
                    showInputModal = false
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
            .padding(.vertical, 16)
            
            Divider()
            
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    
                    TextField("Название", text: $viewModel.dishName)
                    
                    Divider()
                    
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
                
                Divider()
                
                Stepper("Количество: \(viewModel.quantity)", value: $viewModel.quantity, in: 1...100)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            Spacer()
        }
        .presentationDetents([.height(280)])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - BillItems Section
    
    @ViewBuilder
    private func billItemsSection(receiptItems: Binding<[BillItem]>, participants: [Participant]) -> some View {
        VStack(spacing: 16) {
            HStack {
                Text("Позиции чека")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(receiptItems.count) поз.")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(receiptItems.isEmpty ? Color.gray.opacity(0.1) : Color.green.opacity(0.1))
                    .foregroundStyle(receiptItems.isEmpty ? .gray : .green)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            if receiptItems.isEmpty {
                EmptyStateView(
                    icon: "fork.knife",
                    title: "Нет позиций чека",
                    description: "Добавьте блюда, чтобы начать распределение счёта",
                    exampleText: "Добавьте все блюда из чека и отметьте, кто что ел",
                    accentColor: .blue
                )
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(receiptItems) { $billItem in
                        BillItemCard(item: $billItem,
                                     participants: participants,
                                     onSplitEqually: { viewModel.equalSplitPayers(for: &billItem, participants: session.participants) },
                                     onReset: { viewModel.resetPayers(for: &billItem) },
                                     onDelete: { viewModel.deleteItemCard(for: billItem, from: &session.receiptItems) })
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
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
}

// MARK: - Preview

#Preview {
    @Previewable @State var session = BillSession()
    
    session.participants = [
        Participant(name: "Оля"),
        Participant(name: "Маша"),
        Participant(name: "Даша")
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
