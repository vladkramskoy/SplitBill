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
    
    func distributedAmount(from receiptItems: [BillItem]) -> Double {
        receiptItems
            .flatMap { billItem in
                billItem.units
                    .filter { !$0.payers.isEmpty }
                    .map { _ in billItem.pricePerUnit }
            }
            .reduce(0, +)
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
        
        AnalyticsService.logReceiptItemAdded(totalItems: receiptItems.count)
    }
    
    func equalSplitPayers(for item: inout BillItem, participants: [Participant]) {
        for index in item.units.indices {
            item.units[index].payers.append(
                contentsOf: participants.map { $0.id }.filter { !item.units[index].payers.contains($0) }
            )
        }
        
        AnalyticsService.logItemizedSplitEqually(itemName: item.name, participants: participants.count)
    }
    
    func resetPayers(for item: inout BillItem) {
        for index in item.units.indices {
            item.units[index].payers = []
        }
        
        AnalyticsService.logItemizedSplitReset(itemName: item.name)
    }
    
    func deleteItemCard(for item: BillItem, from items: inout [BillItem]) {
        items.removeAll { $0.id == item.id }
        
        AnalyticsService.logReceiptItemRemoved(totalItems: items.count)
    }
}
