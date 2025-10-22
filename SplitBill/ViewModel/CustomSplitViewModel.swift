//
//  CustomSplitViewModel.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 22.10.2025.
//

import Foundation

final class CustomSplitViewModel: ObservableObject {
    @Published var amountPaymentInput = ""
    @Published var selectedPersonIndex = 0
}
