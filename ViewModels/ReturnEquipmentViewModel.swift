import Foundation
import Combine

@MainActor
final class ReturnEquipmentViewModel: ObservableObject {

    @Published var activeLoans: [Loan] = []
    @Published var errorMessage: String?
    @Published var returnCompleted = false

    private let repository: EquipmentRepository
    private let useCase: CompleteEquipmentReturn

    init(repository: EquipmentRepository) {
        self.repository = repository
        self.useCase = CompleteEquipmentReturn(repository: repository)
    }

    func loadActiveLoans() {
        do {
            activeLoans = try repository.fetchActiveLoans()
            errorMessage = nil
        } catch {
            errorMessage = "Unable to load current equipment loans."
        }
    }

    func returnEquipment(_ loan: Loan) {
        do {
            try useCase.execute(loan: loan)

            updateWidget()

            errorMessage = nil
            returnCompleted = true
            loadActiveLoans()

        } catch EquipmentLoanError.loanAlreadyReturned {
            errorMessage = "This equipment has already been returned."

        } catch {
            errorMessage = "Unable to complete the equipment return."
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
            // The return was already completed successfully.
            // Widget refresh can fail without cancelling the return.
        }
    }
}
