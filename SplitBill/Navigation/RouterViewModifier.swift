//
//  RouterViewModifier.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 26.09.2025.
//

import SwiftUI

struct RouterViewModifier: ViewModifier {
    @State private var router = Router()
    
    private func routeView(for route: Route) -> some View {
        Group {
            switch route {
            case .billAmount:
                BillAmountView()
            case .splitMethod:
                SplitMethodView()
            }
        }
        .environment(router)
    }
    
    func body(content: Content) -> some View {
        NavigationStack(path: $router.path) {
            content
                .environment(router)
                .navigationDestination(for: Route.self) { route in
                    routeView(for: route)
                }
        }
    }
}

extension View {
    func withRouter() -> some View {
        modifier(RouterViewModifier())
    }
}
