import SwiftUI
import CoreData

@main
struct CampusEquipmentManagerApp: App {
    let persistenceController = PersistenceController.shared

    private var repository: EquipmentRepository {
        CoreDataEquipmentRepository(
            viewContext: persistenceController
                .container
                .viewContext
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                repository: repository
            )
        }
    }
}
