import Foundation

struct FindOverdueLoans {
    
    private let repository: EquipmentRepository
    
    init(repository: EquipmentRepository) {
        self.repository = repository
    }
    
    func execute() throws -> [Loan] {
        return try repository.fetchOverdueLoans()
    }
}
