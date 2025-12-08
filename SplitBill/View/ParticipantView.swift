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
        VStack(spacing: 0) {
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
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [.clear, Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 15)
                .allowsHitTesting(false)
            }
            
            Button(action: {
                session.participants = viewModel.participants
                session.startSession()
                router.navigateToBillAmount()
            }) {
                Text("Начать")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .disabled(!viewModel.canProceed)
            .padding()
        }
        .navigationTitle("Разделить счет")
        .ignoresSafeArea(.keyboard)
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
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var session = BillSession()
    
    ParticipantView()
        .environment(session)
        .withRouter()
}
