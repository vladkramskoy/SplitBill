//
//  ShareServiceTests.swift
//  SplitBillTests
//
//  Created by Vlad Kramskoy on 25.02.2026.
//

import SwiftUI
import Testing
@testable import SplitBill

struct ShareServiceTests {
    @Test func formatForParticipantWithoutTip() async throws {
        let result = ShareService.formatForParticipant(
            participantName: "Vlad",
            participantAmount: 1500,
            totalAmount: 5000,
            billAmount: 5000,
            tipAmount: 0)
        #expect(result.contains("Vlad"))
        #expect(result.contains("1\u{00A0}500 ₽"))
        #expect(result.contains("Общая сумма:"))
        #expect(result.contains("📊"))
        #expect(result.contains("https://apps.apple.com/app/id6756733884"))
    }
    
    @Test func formatForParticipantWithTip() async throws {
        let result = ShareService.formatForParticipant(
            participantName: "Vlad",
            participantAmount: 1500,
            totalAmount: 5000,
            billAmount: 5000,
            tipAmount: 500)
        #expect(result.contains("Сумма счёта:"))
        #expect(result.contains("Чаевые:"))
        #expect(result.contains("Итого:"))
        #expect(result.contains("—————————————"))
    }
    
    @Test func formatForParticipantEdgeCase() async throws {
        let result = ShareService.formatForParticipant(
            participantName: "Vlad",
            participantAmount: 0,
            totalAmount: 0,
            billAmount: 0,
            tipAmount: 0)
        #expect(result.isEmpty == false)
        #expect(result.contains("Общая сумма: 0 ₽"))
        #expect(result.contains("Vlad — 0 ₽"))
        #expect(!result.contains("Чаевые:"))
    }
    
    @Test func formatForParticipantSpecialСharacters() async throws {
        let result = ShareService.formatForParticipant(
            participantName: "Vlad 🎉",
            participantAmount: 1500,
            totalAmount: 5000,
            billAmount: 5000,
            tipAmount: 0)
        #expect(result.contains("Vlad 🎉"))
        #expect(result.contains("Общая сумма:"))
        #expect(result.contains("📊"))
    }
    
    @Test func formatFullBillWithoutTip() async throws {
        let participant1 = Participant(name: "Sasha", color: .blue)
        let participant2 = Participant(name: "Dasha", color: .green)
        let participants = [participant1, participant2]
        
        let participantAmount: [UUID: Double] = [
            participant1.id: 2500,
            participant2.id: 2500
        ]
        
        let result = ShareService.formatFullBill(
            totalAmount: 5000,
            distributedAmount: 5000,
            billAmount: 5000,
            tipAmount: 0,
            participants: participants,
            participantAmount: participantAmount)
        
        #expect(result.contains("Общая сумма:"))
        #expect(result.contains("5\u{00A0}000 ₽"))
        #expect(result.contains("Dasha"))
        #expect(result.contains("👥"))
        #expect(result.contains("—"))
    }
    
    @Test func formatFullBillWithTip() async throws {
        let participant1 = Participant(name: "Sasha", color: .blue)
        let participant2 = Participant(name: "Dasha", color: .green)
        let participants = [participant1, participant2]
        
        let participantAmount: [UUID: Double] = [
            participant1.id: 2500,
            participant2.id: 2500
        ]
        
        let result = ShareService.formatFullBill(
            totalAmount: 5500,
            distributedAmount: 5500,
            billAmount: 5000,
            tipAmount: 500,
            participants: participants,
            participantAmount: participantAmount)
        
        #expect(result.contains("Сумма счёта: 5\u{00A0}000 ₽"))
        #expect(result.contains("Чаевые: 500 ₽"))
        #expect(result.contains("Итого: 5\u{00A0}500 ₽"))
        #expect(result.contains("—————————————"))
    }
    
    @Test func formatFullBillNoParticipants() async throws {
        let participants: [Participant] = []
        let participantAmount: [UUID: Double] = [:]
        
        let result = ShareService.formatFullBill(
            totalAmount: 5000,
            distributedAmount: 5000,
            billAmount: 5000,
            tipAmount: 0,
            participants: participants,
            participantAmount: participantAmount)
        
        #expect(result.contains("Общая сумма:"))
        #expect(result.isEmpty == false)
    }
    
    @Test func formatFullBillOneParticipant() async throws {
        let participant = Participant(name: "Sasha", color: .blue)
        let participants = [participant]
        let participantAmount: [UUID: Double] = [participant.id: 2500]
        
        let result = ShareService.formatFullBill(
            totalAmount: 1000,
            distributedAmount: 1000,
            billAmount: 1000,
            tipAmount: 0,
            participants: participants,
            participantAmount: participantAmount)
        
        #expect(result.contains("Sasha"))
        #expect(result.contains("1\u{00A0}000 ₽"))
    }
    
    @Test func formatFullBillNoParticipantAmount() async throws {
        let participant = Participant(name: "Dasha", color: .blue)
        let participants = [participant]
        let participantAmount: [UUID: Double] = [:]
        
        let result = ShareService.formatFullBill(
            totalAmount: 1000,
            distributedAmount: 1000,
            billAmount: 1000,
            tipAmount: 0,
            participants: participants,
            participantAmount: participantAmount)
        
        #expect(result.contains("Dasha — -"))
    }
}
