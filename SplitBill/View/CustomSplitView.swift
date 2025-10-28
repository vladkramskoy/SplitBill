//
//  CustomSplitView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 31.05.2025.
//

import SwiftUI

struct CustomSplitView: View {
    @Environment(Router.self) private var router
    @EnvironmentObject private var sharedData: SharedData
    @StateObject private var viewModel = CustomSplitViewModel()
    @State private var showAlert = false
    @State private var showInputModal = false
    @FocusState private var isTextFieldFocused: Bool
    
    var maxCharacters = 6
    var showPopup: () -> Void
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Распределено")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Text("\(sharedData.destributedAmountInString) ₽")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Осталось")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Text("\(sharedData.remainingAmountInString) ₽")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(sharedData.remainingAmount > 0 ? .orange : .green)
                            }
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color(.systemGray5))
                                    .frame(height: 6)
                                
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            colors: sharedData.progressForDestributedAmount >= 1 ? [.green] : [.blue],
                                            startPoint: .leading,
                                            endPoint: .trailing)
                                    )
                                    .frame(width: geometry.size.width * min(1, sharedData.progressForDestributedAmount), height: 6)
                            }
                        }
                        .frame(height: 6)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Участники")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text("\(sharedData.participants.count) чел.")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundStyle(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        LazyVStack(spacing: 12) {
                            ForEach(sharedData.participants) { participant in
                                ParticipantRow(name: participant.name, amount: participant.mustPayAll)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
            }
            
            floatingAddButton
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("По деньгам")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    
                    // TODO: process refactor
                    
//                    if sharedData.containsAmounts {
//                        showAlert = true
//                    } else {
//                        router.pop()
//                    }
                } label: {
                    Image(systemName: "chevron.backward")
                    Text("Назад")
                }
                .alert("Вернуться?", isPresented: $showAlert) {
                    Button("Отмена", role: .cancel) {}
                    Button("Сбросить чеки", role: .destructive) {
                        withAnimation {
                            sharedData.resetToInitialState()
                            router.popToRoot()
                        }
                    }
                }
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
    
    // MARK: - Floating Add Button

    private var floatingAddButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    sharedData.amountPaymentInput = ""
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
                    sharedData.addPaymentSharesForCustomSplit()
                    showInputModal = false
                }
                .fontWeight(.semibold)
                .foregroundStyle(sharedData.amountPaymentInput.isEmpty ? .gray : .blue)
                .disabled(sharedData.amountPaymentInput.isEmpty)
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
                        TextField("0", text: $sharedData.amountPaymentInput)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 28, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .onChange(of: sharedData.amountPaymentInput) { oldValue, newValue in
                                let formatted = InputValidator.formatCurrencyInput(newValue)
                                if formatted != newValue {
                                    sharedData.amountPaymentInput = formatted
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
                            ForEach(0..<sharedData.participants.count, id: \.self) { index in
                                Button(action: {
                                    sharedData.selectedPersonIndex = index
                                }) {
                                    VStack(spacing: 8) {
                                        Circle()
                                            .fill(sharedData.selectedPersonIndex == index ? Color.blue : Color(.systemGray5))
                                            .frame(width: 50, height: 50)
                                            .overlay {
                                                Text(String(sharedData.participants[index].name.prefix(1)))
                                                    .font(.system(size: 18, weight: .semibold))
                                                    .foregroundStyle(sharedData.selectedPersonIndex == index ? .white : .primary)
                                            }
                                        
                                        Text(sharedData.participants[index].name)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundStyle(sharedData.selectedPersonIndex == index ? .blue : .primary)
                                            
                                    }
                                }
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
}

// MARK: - Preview

#Preview {
    let sharedData = SharedData()
    sharedData.participants = [
        Participant(name: "Оля"),
        Participant(name: "Маша"),
        Participant(name: "Даша")
    ]
    sharedData.billAmount = "5000"
    
    return NavigationStack() {
        CustomSplitView(showPopup: {})
            .environmentObject(sharedData)
            .withRouter()
    }
}
