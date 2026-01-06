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
                        .foregroundStyle(Color.SplitBill.blueCyanGradient)
                        .padding(.top, 50)
                    
                    Text("Кто участвует?")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Добавьте участников для разделения счёта")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 16) {
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
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    GeometryReader { _ in
                        if viewModel.participants.isEmpty {
                            emptyState
                        } else {
                            participantSection
                        }
                    }
                }
                .padding(.horizontal)
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
    
    // MARK: - Participants Section
    
    private var participantSection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Участники")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("\(viewModel.participants.count) чел.")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundStyle(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                LazyVStack(spacing: 7) {
                    ForEach(Array(viewModel.participants.enumerated()), id: \.element.id) { index, participant in
                        SimpleParticipantRow(participant: participant, onDelete: { viewModel.removeParticipant(at: IndexSet(integer: index))
                        })
                        
                        if participant.id != viewModel.participants.last?.id {
                            Divider()
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Spacer(minLength: 80)
        }
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 60))
                .foregroundStyle(.secondary.opacity(0.5))
                .padding(.top, 40)
            
            Text("Нет участников")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text("Добавьте минимум двух участников")
                .font(.subheadline)
                .foregroundStyle(.secondary.opacity(0.8))
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var session = BillSession()
    
    ParticipantView()
        .environment(session)
        .withRouter()
}
