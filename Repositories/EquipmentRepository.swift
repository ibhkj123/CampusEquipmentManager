import Foundation

protocol EquipmentRepository {
    func fetchEquipment() throws -> [Equipment]

    func fetchActiveLoans() throws -> [Loan]

    func fetchOverdueLoans() throws -> [Loan]

    func fetchDueTodayLoans() throws -> [Loan]

    func createEquipment(
        name: String,
        category: String,
        serialNumber: String
    ) throws -> Equipment

    func saveEquipment(_ equipment: Equipment) throws

    func saveLoan(_ loan: Loan) throws

    func returnLoan(_ loan: Loan) throws
}
