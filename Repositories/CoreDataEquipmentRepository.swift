import CoreData

final class CoreDataEquipmentRepository: EquipmentRepository {
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func fetchEquipment() throws -> [Equipment] {
        let request: NSFetchRequest<Equipment> = Equipment.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        return try viewContext.fetch(request)
    }
    
    func fetchActiveLoans() throws -> [Loan] {
        let request: NSFetchRequest<Loan> = Loan.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "returnedDate == nil"
        )
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "dueDate", ascending: true)
        ]
        
        return try viewContext.fetch(request)
    }
    
    func fetchOverdueLoans() throws -> [Loan] {
        let request: NSFetchRequest<Loan> = Loan.fetchRequest()
        
        let today = Calendar.current.startOfDay(for: Date())
        
        request.predicate = NSPredicate(
            format: "dueDate < %@ AND returnedDate == nil",
            today as NSDate
        )
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "dueDate", ascending: true)
        ]
        
        return try viewContext.fetch(request)
    }
    
    func fetchDueTodayLoans() throws -> [Loan] {
        let request: NSFetchRequest<Loan> = Loan.fetchRequest()
        
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTomorrow = calendar.date(
            byAdding: .day,
            value: 1,
            to: startOfToday
        )!
        
        request.predicate = NSPredicate(
            format: "dueDate >= %@ AND dueDate < %@ AND returnedDate == nil",
            startOfToday as NSDate,
            startOfTomorrow as NSDate
        )
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "dueDate", ascending: true)
        ]
        
        return try viewContext.fetch(request)
    }
    
    func createEquipment(
        name: String,
        category: String,
        serialNumber: String
    ) throws -> Equipment {

        let equipment = Equipment(context: viewContext)

        equipment.id = UUID()
        equipment.name = name
        equipment.category = category
        equipment.serialNumber = serialNumber
        equipment.isAvailable = true

        try viewContext.save()

        return equipment
    }
    
    func saveEquipment(_ equipment: Equipment) throws {
        try viewContext.save()
    }
    
    func saveLoan(_ loan: Loan) throws {
        try viewContext.save()
    }
    
    func returnLoan(_ loan: Loan) throws {
        loan.returnedDate = Date()
        loan.equipment?.isAvailable = true
        
        try viewContext.save()
    }
}
