//
//  SupportView.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 21.05.2025.
//

import SwiftUI

struct SupportView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // App Description
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About SplitBill")
                            .font(.headline)
                        Text("SplitBill helps you easily split bills and expenses with friends, family, or roommates. Track who owes what and settle up with ease.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    
                    // Helpful Resources Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Helpful Resources")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                        // Resource Links
                        ResourceLink(
                            icon: "book.fill",
                            title: "User Guide",
                            description: "Learn how to use SplitBill effectively",
                            color: .blue
                        )
                        
                        ResourceLink(
                            icon: "lightbulb.fill",
                            title: "Tips & Tricks",
                            description: "Discover helpful tips for splitting bills",
                            color: .yellow
                        )
                        
                        ResourceLink(
                            icon: "questionmark.circle.fill",
                            title: "FAQ",
                            description: "Frequently asked questions and answers",
                            color: .green
                        )
                        
                        ResourceLink(
                            icon: "envelope.fill",
                            title: "Contact Support",
                            description: "Get help from our support team",
                            color: .orange
                        )
                        
                        ResourceLink(
                            icon: "star.fill",
                            title: "Rate SplitBill",
                            description: "Share your experience on the App Store",
                            color: .purple
                        )
                        
                        ResourceLink(
                            icon: "exclamationmark.bubble.fill",
                            title: "Report an Issue",
                            description: "Help us improve by reporting bugs",
                            color: .red
                        )
                    }
                    .padding()
                    
                    // Additional Information
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Need More Help?")
                            .font(.headline)
                        Text("If you can't find what you're looking for in these resources, please don't hesitate to contact our support team. We're here to help!")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Support")
        }
    }
}

struct ResourceLink: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    SupportView()
}
