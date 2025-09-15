//
//  CalculationViewModel.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 15.09.2025.
//

import Foundation

final class CalculationViewModel: ObservableObject {
    var shareData: SharedData
    
    init(sharedData: SharedData) {
        self.shareData = sharedData
    }
}
