import Foundation
import Combine

@MainActor
final class RecordLoanViewModel: ObservableObject {

    @Published var errorMessage: String?
    @Published var loanRecorded = false

    private let useCase: RecordEquipmentLoan
    private let repository: EquipmentRepository

    init(repository: EquipmentRepository) {
        self.repository = repository
        self.useCase = RecordEquipmentLoan(repository: repository)
    }

    func recordLoan(
        equipment: Equipment,
        borrowerName: String,
        dueDate: Date
    ) {
        do {
            try useCase.execute(
                equipment: equipment,
                borrowerName: borrowerName,
                dueDate: dueDate
            )

            updateWidget()

            errorMessage = nil
            loanRecorded = true

        } catch EquipmentLoanError.equipmentAlreadyOnLoan {
            errorMessage = "This equipment is already on loan."

        } catch EquipmentLoanError.invalidDueDate {
            errorMessage = "The due date must be today or a future date."

        } catch {
            errorMessage = "Unable to record the equipment loan."
        }
    }

    private func updateWidget() {
        do {
            let overdueLoans = try repository.fetchOverdueLoans()
            let dueTodayLoans = try repository.fetchDueTodayLoans()

            let overdueNames = overdueLoans.compactMap {
                $0.equipment?.name
            }

            WidgetDataManager.update(
                overdueCount: overdueLoans.count,
                dueTodayCount: dueTodayLoans.count,
                overdueNames: overdueNames
            )
        } catch {
            // The loan was already recorded successfully.
            // Widget refresh can fail without cancelling the loan.
        }
    }
}
