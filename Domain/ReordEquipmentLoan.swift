import Foundation
import CoreData

struct RecordEquipmentLoan {
    
    private let repository: EquipmentRepository
    
    init(repository: EquipmentRepository) {
        self.repository = repository
    }
    
    func execute(
        equipment: Equipment,
        borrowerName: String,
        dueDate: Date
    ) throws {
        
        guard equipment.isAvailable else {
            throw EquipmentLoanError.equipmentAlreadyOnLoan
        }
        
        let today = Calendar.current.startOfDay(for: Date())
        let dueDay = Calendar.current.startOfDay(for: dueDate)
        
        guard dueDay >= today else {
            throw EquipmentLoanError.invalidDueDate
        }
        
        let loan = Loan(context: equipment.managedObjectContext!)
        loan.id = UUID()
        loan.borrowerName = borrowerName
        loan.checkoutDate = Date()
        loan.dueDate = dueDate
        loan.equipment = equipment
        loan.returnedDate = nil
        
        equipment.isAvailable = false
        
        try repository.saveLoan(loan)
    }
}
