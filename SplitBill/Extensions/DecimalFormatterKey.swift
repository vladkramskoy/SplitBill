//
//  DecimalFormatterKey.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 12.03.2026.
//

import SwiftUI

private struct DecimalFormatterKey: EnvironmentKey {
    static let defaultValue: DecimalFormatting = DecimalFormatter()
}

extension EnvironmentValues {
    var decimalFormatter: DecimalFormatting {
        get { self[DecimalFormatterKey.self] }
        set { self[DecimalFormatterKey.self] = newValue }
    }
}
