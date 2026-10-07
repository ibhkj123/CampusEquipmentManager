import Foundation

enum EquipmentLoanError: Error, Equatable {
    case equipmentAlreadyOnLoan
    case invalidDueDate
    case loanAlreadyReturned
}
