//
//  SplitBillViewModel.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 22.05.2025.
//

import Foundation

final class SplitBillViewModel: ObservableObject {
    
    let minParticipants = 2
    let maxParticipants = 8
    
    @Published var participant: [Participant] = []
}
