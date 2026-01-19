//
//  Participant.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 22.05.2025.
//

import SwiftUI

struct Participant: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    
    init(name: String, color: Color) {
        self.name = name
        self.color = color
    }
}

