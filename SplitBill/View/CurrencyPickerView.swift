//
//  CurrencyPickerView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 13.03.2026.
//

import SwiftUI

struct CurrencyPickerView: View {
    @AppStorage("currencyCode") private var currencyCode: String = "RUB"
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    
    var filteredResult: [Currency] {
        let combined = Currency.popular + Currency.all
        return combined.filter {
            $0.localizedName.localizedCaseInsensitiveContains(searchText) ||
            $0.code.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if searchText.isEmpty {
                    Section("Популярные") {
                        ForEach(Currency.popular) { currency in
                            currencyRow(currency)
                        }
                    }
                    
                    Section("Все валюты") {
                        ForEach(Currency.all) { currency in
                            currencyRow(currency)
                        }
                    }
                }
                
                Section("Результаты") {
                    ForEach(filteredResult) { currency in
                        currencyRow(currency)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Поиск валюты")
            .navigationTitle("Валюта")
            .navigationBarTitleDisplayMode(.inline)
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
    }
    
    private func currencyRow(_ currency: Currency) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(currency.localizedName)
                    .font(.body)
                    .foregroundStyle(.primary)
                Text(currency.code)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if currencyCode == currency.code {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.blue)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            currencyCode = currency.code
            dismiss()
        }
    }
}

#Preview {
    CurrencyPickerView()
}
