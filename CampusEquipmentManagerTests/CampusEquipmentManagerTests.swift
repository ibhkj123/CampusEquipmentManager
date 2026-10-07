import XCTest
import CoreData
@testable import CampusEquipmentManager

final class CampusEquipmentManagerTests: XCTestCase {
    
    private var persistenceController: PersistenceController!
    private var context: NSManagedObjectContext!
    private var repository: MockEquipmentRepository!
    
    override func setUp() {
        super.setUp()
        
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
        repository = MockEquipmentRepository()
    }
    
    override func tearDown() {
        repository = nil
        context = nil
        persistenceController = nil
        
        super.tearDown()
    }
    
    // MARK: - Record Equipment Loan
    
    func testAvailableEquipmentCanBeLoaned() throws {
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Camera"
        equipment.category = "Camera"
        equipment.serialNumber = "CAM-001"
        equipment.isAvailable = true
        
        let useCase = RecordEquipmentLoan(repository: repository)
        
        let dueDate = Calendar.current.date(
            byAdding: .day,
            value: 7,
            to: Date()
        )!
        
        try useCase.execute(
            equipment: equipment,
            borrowerName: "Alex",
            dueDate: dueDate
        )
        
        XCTAssertFalse(equipment.isAvailable)
        XCTAssertEqual(repository.loans.count, 1)
        XCTAssertEqual(repository.loans.first?.borrowerName, "Alex")
    }
    
    func testEquipmentAlreadyOnLoanCannotBeLoaned() {
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Camera"
        equipment.category = "Camera"
        equipment.serialNumber = "CAM-002"
        equipment.isAvailable = false
        
        let useCase = RecordEquipmentLoan(repository: repository)
        
        let dueDate = Calendar.current.date(
            byAdding: .day,
            value: 7,
            to: Date()
        )!
        
        XCTAssertThrowsError(
            try useCase.execute(
                equipment: equipment,
                borrowerName: "Alex",
                dueDate: dueDate
            )
        ) { error in
            XCTAssertEqual(
                error as? EquipmentLoanError,
                .equipmentAlreadyOnLoan
            )
        }
    }
    
    // MARK: - Find Overdue Loans
    
    func testOverdueLoanIsFound() throws {
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Projector"
        equipment.category = "Projector"
        equipment.serialNumber = "PROJ-001"
        equipment.isAvailable = false
        
        let loan = Loan(context: context)
        loan.id = UUID()
        loan.borrowerName = "Alex"
        loan.checkoutDate = Calendar.current.date(
            byAdding: .day,
            value: -10,
            to: Date()
        )
        loan.dueDate = Calendar.current.date(
            byAdding: .day,
            value: -2,
            to: Date()
        )
        loan.returnedDate = nil
        loan.equipment = equipment
        
        repository.loans = [loan]
        
        let useCase = FindOverdueLoans(repository: repository)
        let overdueLoans = try useCase.execute()
        
        XCTAssertEqual(overdueLoans.count, 1)
        XCTAssertEqual(overdueLoans.first?.borrowerName, "Alex")
    }
    
    func testFutureLoanIsNotOverdue() throws {
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Projector"
        equipment.category = "Projector"
        equipment.serialNumber = "PROJ-002"
        equipment.isAvailable = false
        
        let loan = Loan(context: context)
        loan.id = UUID()
        loan.borrowerName = "Alex"
        loan.checkoutDate = Date()
        loan.dueDate = Calendar.current.date(
            byAdding: .day,
            value: 7,
            to: Date()
        )
        loan.returnedDate = nil
        loan.equipment = equipment
        
        repository.loans = [loan]
        
        let useCase = FindOverdueLoans(repository: repository)
        let overdueLoans = try useCase.execute()
        
        XCTAssertTrue(overdueLoans.isEmpty)
    }
    
    // MARK: - Complete Equipment Return
    
    func testActiveLoanCanBeReturned() throws {
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Camera"
        equipment.category = "Camera"
        equipment.serialNumber = "CAM-003"
        equipment.isAvailable = false
        
        let loan = Loan(context: context)
        loan.id = UUID()
        loan.borrowerName = "Alex"
        loan.checkoutDate = Date()
        loan.dueDate = Calendar.current.date(
            byAdding: .day,
            value: 7,
            to: Date()
        )
        loan.returnedDate = nil
        loan.equipment = equipment
        
        repository.loans = [loan]
        
        let useCase = CompleteEquipmentReturn(repository: repository)
        
        try useCase.execute(loan: loan)
        
        XCTAssertNotNil(loan.returnedDate)
        XCTAssertTrue(equipment.isAvailable)
    }
    
    func testReturnedLoanCannotBeReturnedAgain() {
        let equipment = Equipment(context: context)
        equipment.id = UUID()
        equipment.name = "Camera"
        equipment.category = "Camera"
        equipment.serialNumber = "CAM-004"
        equipment.isAvailable = true
        
        let loan = Loan(context: context)
        loan.id = UUID()
        loan.borrowerName = "Alex"
        loan.checkoutDate = Calendar.current.date(
            byAdding: .day,
            value: -5,
            to: Date()
        )
        loan.dueDate = Calendar.current.date(
            byAdding: .day,
            value: 2,
            to: Date()
        )
        loan.returnedDate = Date()
        loan.equipment = equipment
        
        repository.loans = [loan]
        
        let useCase = CompleteEquipmentReturn(repository: repository)
        
        XCTAssertThrowsError(
            try useCase.execute(loan: loan)
        ) { error in
            XCTAssertEqual(
                error as? EquipmentLoanError,
                .loanAlreadyReturned
            )
        }
    }
}
