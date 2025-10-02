//
//  ParticipantView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 21.05.2025.
//

import SwiftUI

struct ParticipantView: View {
    @EnvironmentObject private var sharedData: SharedData
    @Environment(Router.self) private var router
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section {
                    HStack {
                        TextField("Введите имя", text: $sharedData.nameInput)
                            .focused($isTextFieldFocused)
                        
                        Button(action: {
                            sharedData.addParticipant(for: sharedData.nameInput)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(sharedData.nameInput.isEmpty ? .gray : .blue)
                        }
                        .disabled(sharedData.nameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    List {
                        ForEach(sharedData.participants) { item in
                            Text(item.name)
                        }
                        .onDelete(perform: sharedData.removeParticipant(at:))
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
                router.navigateToBillAmount()
            }) {
                Text("Начать")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
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
    }
}

#Preview {
    @Previewable @StateObject var sharedData = SharedData()
    
    ParticipantView()
        .environmentObject(sharedData)
        .withRouter()
}
