import SwiftUI
import CoreData

struct ContentView: View {
    private let repository: EquipmentRepository

    init(repository: EquipmentRepository) {
        self.repository = repository
    }

    var body: some View {
        DashboardView(
            repository: repository
        )
    }
}

#Preview {
    ContentView(
        repository: CoreDataEquipmentRepository(
            viewContext: PersistenceController.shared
                .container
                .viewContext
        )
    )
}
