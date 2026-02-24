//
//  SharingModalView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 18.02.2026.
//

import SwiftUI

struct SharingModalView: View {
    let shareText: String
    let onShare: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Предпросмотр сообщения")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        Text(shareText)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                ShareLink(item: shareText,
                          subject: Text("Раздели счёт"),
                          preview: SharePreview("Раздели счёт")
                ) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 22))
                        Text("Поделиться")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(Color.SplitBill.blueCyanGradient.opacity(0.8))
                    .clipShape(Capsule())
                    .shadow(color: Color.blue.opacity(0.4), radius: 12, x: 0, y: 6)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    onShare()
                })
                .padding(.horizontal)
                .padding(.bottom)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                }
            }
        }
        .background(Color(.systemBackground).ignoresSafeArea())
    }
}

#Preview {
    SharingModalView(
        shareText: "Текст для шаринга",
        onShare: { print("Share tapped") }
    )
}
