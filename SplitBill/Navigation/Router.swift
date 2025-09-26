//
//  Router.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 26.09.2025.
//

import SwiftUI

@Observable
final class Router {
    var path = NavigationPath()
    
    func navigateToBillAmount() {
        path.append(Route.billAmount)
    }
    
    func navigateToCalculation() {
        path.append(Route.calculation)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}

enum Route: Hashable {
    case billAmount
    case calculation
}
