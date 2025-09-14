//
//  Coordinator.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 10.09.2025.
//

import SwiftUI

final class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}
