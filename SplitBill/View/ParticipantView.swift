//
//  ParticipantView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 21.05.2025.
//

import SwiftUI

struct ParticipantView: View {
    @Environment(Router.self) private var router
    @Environment(BillSession.self) private var session
    @StateObject private var viewModel = ParticipantViewModel()
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color.SplitBill.backgroundLight
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(Color.SplitBill.primaryGradient)
                        .padding(.top, 50)
                    
                    Text("Кто участвует?")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Добавьте участников для разделения счета")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Form {
                    Section {
                        HStack {
                            TextField("Введите имя", text: $viewModel.nameInput)
                                .focused($isTextFieldFocused)
                            
                            Button(action: {
                                viewModel.addParticipant(for: viewModel.nameInput)
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(viewModel.nameInput.isEmpty ? .gray : .blue)
                            }
                            .disabled(viewModel.nameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                        List {
                            ForEach(viewModel.participants) { item in
                                Text(item.name)
                            }
                            .onDelete(perform: viewModel.removeParticipant)
                        }
                    } header: {
                        Text("Участники")
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        isTextFieldFocused = false
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                }
            }
            .onAppear {
                AnalyticsService.logScreen(name: "participants_screen")
            }
            
            NextButton(title: "Начать разделение", action: {
                session.participants = viewModel.participants
                session.startSession()
                router.navigateToBillAmount()
            }, isActive: viewModel.canProceed)
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var session = BillSession()
    
    ParticipantView()
        .environment(session)
        .withRouter()
}
