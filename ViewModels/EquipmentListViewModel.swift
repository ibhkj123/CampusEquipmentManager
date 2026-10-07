import Foundation
import Combine

@MainActor
final class EquipmentListViewModel: ObservableObject {
    @Published var equipment: [Equipment] = []
    @Published var errorMessage: String?

    private let repository: EquipmentRepository

    init(repository: EquipmentRepository) {
        self.repository = repository
    }

    func loadEquipment() {
        do {
            equipment = try repository.fetchEquipment()
            errorMessage = nil
        } catch {
            errorMessage = "Unable to load equipment."
        }
    }

    func addEquipment(
        name: String,
        category: String,
        serialNumber: String
    ) {
        do {
            _ = try repository.createEquipment(
                name: name,
                category: category,
                serialNumber: serialNumber
            )
            loadEquipment()
        } catch {
            errorMessage = "Unable to save equipment."
        }
    }

    func importSharedEquipment() {
        let sharedDataManager = SharedDataManager()

        guard let text = sharedDataManager.readPendingSharedText() else {
            return
        }

        let parts = text.components(separatedBy: " - ")

        guard parts.count >= 3 else {
            errorMessage = "Shared equipment must use: Name - Category - Serial Number."
            return
        }

        let name = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
        let category = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
        let serialNumber = parts[2].trimmingCharacters(in: .whitespacesAndNewlines)

        guard !name.isEmpty,
              !category.isEmpty,
              !serialNumber.isEmpty else {
            errorMessage = "Shared equipment information is incomplete."
            return
        }

        addEquipment(
            name: name,
            category: category,
            serialNumber: serialNumber
        )
    }
}
