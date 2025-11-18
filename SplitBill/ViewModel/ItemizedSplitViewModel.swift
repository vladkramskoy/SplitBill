//
//  ItemizedSplitView.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 10.11.2025.
//

import Foundation

final class ItemizedSplitViewModel: ObservableObject {
    @Published var amountPaymentInput = ""
    @Published var dishName = ""
    @Published var quantity = 1
    
    private let formatter: DecimalFormatting
    
    init(formatter: DecimalFormatting = DecimalFormatter()) {
        self.formatter = formatter
    }
    
    func distributedAmount(from items: [BillItem]) -> Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    func remainingAmount(total: Double, items: [BillItem]) -> Double {
        total - distributedAmount(from: items)
    }
    
    func distributionProgress(total: Double, items: [BillItem]) -> Double {
        guard total > 0 else { return 0 }
        return distributedAmount(from: items) / total
    }
    
    func amountFor(participantId: UUID, receiptItems: [BillItem]) -> Double {
        receiptItems
            .flatMap { billItem in
                billItem.units
                    .filter { $0.payers.contains(participantId) }
                    .map { $0.splitAmount(price: billItem.pricePerUnit) }
            }
            .reduce(0, +)
    }
    
    func addDish(to receiptItems: inout [BillItem]) {
        guard let price = formatter.parse(amountPaymentInput) else { return }
        
        var billItem = BillItem(id: UUID(), name: dishName, quantity: quantity, pricePerUnit: price, units: [])
        
        for _ in 0..<billItem.quantity {
            let billUnit = BillUnit(id: UUID(), payers: [])
            billItem.units.append(billUnit)
        }
        
        receiptItems.append(billItem)
    }
    
    func equalSplitPayers(for item: inout BillItem, participants: [Participant]) {
        for index in item.units.indices {
            item.units[index].payers.append(contentsOf: participants.map { $0.id })
        }
    }
    
    func resetPayers(for item: inout BillItem) {
        for index in item.units.indices {
            item.units[index].payers = []
        }
    }
    
    func deleteItemCard(for item: BillItem, from items: inout [BillItem]) {
        items.removeAll { $0.id == item.id }
    }
}
