import Foundation
import CoreData

final class MockEquipmentRepository: EquipmentRepository {

    var equipment: [Equipment]
    var loans: [Loan]

    private let context: NSManagedObjectContext

    init(
        equipment: [Equipment] = [],
        loans: [Loan] = []
    ) {
        self.equipment = equipment
        self.loans = loans

        self.context = PersistenceController(
            inMemory: true
        ).container.viewContext
    }

    func fetchEquipment() throws -> [Equipment] {
        return equipment
    }

    func fetchActiveLoans() throws -> [Loan] {
        return loans.filter { loan in
            loan.returnedDate == nil
        }
    }

    func fetchOverdueLoans() throws -> [Loan] {
        let today = Calendar.current.startOfDay(for: Date())

        return loans.filter { loan in
            guard let dueDate = loan.dueDate else {
                return false
            }

            return dueDate < today &&
                   loan.returnedDate == nil
        }
    }

    func fetchDueTodayLoans() throws -> [Loan] {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())

        let startOfTomorrow = calendar.date(
            byAdding: .day,
            value: 1,
            to: startOfToday
        )!

        return loans.filter { loan in
            guard let dueDate = loan.dueDate else {
                return false
            }

            return dueDate >= startOfToday &&
                   dueDate < startOfTomorrow &&
                   loan.returnedDate == nil
        }
    }

    func createEquipment(
        name: String,
        category: String,
        serialNumber: String
    ) throws -> Equipment {

        let newEquipment = Equipment(context: context)

        newEquipment.id = UUID()
        newEquipment.name = name
        newEquipment.category = category
        newEquipment.serialNumber = serialNumber
        newEquipment.isAvailable = true

        equipment.append(newEquipment)

        return newEquipment
    }

    func saveEquipment(_ equipment: Equipment) throws {
        if !self.equipment.contains(where: {
            $0.objectID == equipment.objectID
        }) {
            self.equipment.append(equipment)
        }
    }

    func saveLoan(_ loan: Loan) throws {
        loans.append(loan)
    }

    func returnLoan(_ loan: Loan) throws {
        loan.returnedDate = Date()
        loan.equipment?.isAvailable = true
    }
}
