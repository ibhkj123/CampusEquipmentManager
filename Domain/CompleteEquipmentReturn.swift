import Foundation

struct CompleteEquipmentReturn {

    private let repository: EquipmentRepository

    init(repository: EquipmentRepository) {
        self.repository = repository
    }

    func execute(loan: Loan) throws {

        guard loan.returnedDate == nil else {
            throw EquipmentLoanError.loanAlreadyReturned
        }

        try repository.returnLoan(loan)
    }
}
