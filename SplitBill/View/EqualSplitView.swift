//
//  EqualSplitView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 03.10.2025.
//

import SwiftUI

struct EqualSplitView: View {
    @Environment(BillSession.self) private var session
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 20) {
                        VStack(spacing: 12) {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(.blue)
                            
                            Text("Счет разделен!")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Divider()
                        
                        VStack(spacing: 16) {
                            HStack {
                                Text("На человека:")
                                Spacer()
                                Text("₽\(session.equalAmountPerPerson(), specifier: "%.2f")")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.blue)
                            }
                            
                            HStack {
                                Text("Всего участников")
                                Spacer()
                                Text("\(session.participants.count)")
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Детали счета")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            DetailRow(title: "Сумма счета", value: session.billAmount, isTotal: false)
                            DetailRow(title: "Чаевые", value: session.tipAmount, isTotal: false)
                            Divider()
                            DetailRow(title: "Итого к оплате", value: session.totalAmount, isTotal: true)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    
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
                                ParticipantRow(name: participant.name, amount: session.equalAmountPerPerson())
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    
                    VStack(spacing: 12) {
                        Button(action: shareResult) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Поделиться результатами")
                            }
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        Button("Новый расчет") {
                            // TODO: implement it later
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func shareResult() {
        // TODO: implement it later
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
    
    return EqualSplitView()
        .environment(session)
}
