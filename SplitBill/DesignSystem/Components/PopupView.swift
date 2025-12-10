//
//  PopupView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 21.10.2025.
//

import SwiftUI

struct PopupView: View {
    @Binding var isShowingPopup: Bool
    
    let popupTitle: String
    let popupMessage: String
    let popupIcon: String
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isShowingPopup = false
                }
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button(action: {
                        isShowingPopup = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.gray.opacity(0.7))
                    }
                }
                
                Image(systemName: popupIcon)
                    .font(.system(size: 50))
                    .foregroundStyle(.blue)
                
                Text(popupTitle)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(popupMessage)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Button("Понятно") {
                    isShowingPopup = false
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .fontWeight(.semibold)
            }
            .padding(25)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            )
            .padding(40)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.9)))
    }
}

#Preview {
    PopupView(isShowingPopup: .constant(true), popupTitle: "Уведомление", popupMessage: "Это пример описания для popup-окна, с затемненным фоном.", popupIcon: "bell.badge.fill")
}
