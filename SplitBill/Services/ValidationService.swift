//
//  ValidationService.swift
//  SplitBill
//
//  Created by Vlad Kramskoy on 13.01.2026.
//

import Foundation

struct ValidationService {
    static func validateParticipants(_ participants: [Participant]) -> ValidationResult {
        guard participants.count <= 20 else {
            return.failure("Максимум 20 участников")
        }
        return .success
    }
    
    static func validateAmount(_ amount: Double) -> ValidationResult {
        guard amount >= 10 else {
            return .failure("Минимальная сумма: 10 ₽")
        }
        guard amount <= 999_999.99 else {
            return.failure("Максимальная сумма: 999,999.99 ₽")
        }
        return .success
    }
    
    static func validateReceiptItems(_ items: [BillItem]) -> ValidationResult {
        guard items.count <= 50 else {
            return .failure("Максимум 50 позиций в чеке")
        }
        for item in items {
            guard item.quantity <= 99 else {
                return.failure("Максимум 99 порций для «\(item.name)»")
            }
        }
        return .success
    }
    
    static func validatePaymentShares(_ shares: [PaymentShare]) -> ValidationResult {
        guard shares.count <= 100 else {
            return .failure("Максимум 100 платежных долей")
        }
        return .success
    }
    
    static func validateParticipantName(_ name: String) -> ValidationResult {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            return .failure("Имя не может быть пустым")
        }
        guard trimmed.count <= 30 else {
            return.failure("Максимум 30 символов")
        }
        return .success
    }
    
    static func validateDishName(_ name: String) -> ValidationResult {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            return .failure("Название не может быть пустым")
        }
        guard trimmed.count <= 50 else {
            return.failure("Максимум 50 символов")
        }
        return .success
    }

}

enum ValidationResult {
    case success
    case failure(String)
    
    var isValid: Bool {
        if case .success = self { return true }
        return false
    }
    
    var errorMessage: String? {
        if case .failure(let message) = self {
            return message
        }
        return nil
    }
}
