//
//  SplitBillApp.swift
//  SplitBill
//
//  Created by Vladislav Kramskoy on 21.05.2025.
//

import SwiftUI

@main
struct SplitBillApp: App {
    
    @StateObject var data = SharedData()
    
    var body: some Scene {
        WindowGroup {
            ParticipantView()
                .environmentObject(data)
        }
    }
}
