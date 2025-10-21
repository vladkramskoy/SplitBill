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
    @State private var showAlert = false
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
                                Text("Сумма чека")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Text("\(sharedData.billAmount) ₽")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Осталось распределить")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Text("2 500")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.orange)
                            }
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color(.systemGray5))
                                    .frame(height: 6)
                                
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: geometry.size.width * 0.5, height: 6)
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
                                ParticipantRow(name: participant.name, amount: sharedData.amountPerPerson)
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
            
            ToolbarItemGroup(placement: .keyboard) {
                Button {
                    isTextFieldFocused = false
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
                Spacer()
            }
        }
    }
}

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
