import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {

    @Published var availableCount = 0
    @Published var onLoanCount = 0
    @Published var overdueCount = 0
    @Published var dueTodayCount = 0
    @Published var activeLoans: [Loan] = []
    @Published var errorMessage: String?

    private let repository: EquipmentRepository

    init(repository: EquipmentRepository) {
        self.repository = repository
    }

    func loadDashboard() {
        do {
            let equipment = try repository.fetchEquipment()

            availableCount = equipment.filter {
                $0.isAvailable
            }.count

            onLoanCount = equipment.filter {
                !$0.isAvailable
            }.count

            activeLoans = try repository.fetchActiveLoans()

            let overdueLoans = try repository.fetchOverdueLoans()
            overdueCount = overdueLoans.count

            dueTodayCount = try repository.fetchDueTodayLoans().count

            let overdueNames = overdueLoans.compactMap {
                $0.equipment?.name
            }

            WidgetDataManager.update(
                overdueCount: overdueCount,
                dueTodayCount: dueTodayCount,
                overdueNames: overdueNames
            )

            errorMessage = nil
        } catch {
            errorMessage = "Unable to load equipment information."
        }
    }
}
