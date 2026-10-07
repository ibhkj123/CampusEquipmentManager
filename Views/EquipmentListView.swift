import SwiftUI
import CoreData

struct EquipmentListView: View {
    
    @StateObject private var viewModel: EquipmentListViewModel
    
    @State private var showingAddEquipment = false
    
    init(repository: EquipmentRepository) {
        _viewModel = StateObject(
            wrappedValue: EquipmentListViewModel(repository: repository)
        )
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.equipment, id: \.objectID) { equipment in
                NavigationLink {
                    EquipmentDetailView(equipment: equipment)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(equipment.name ?? "Unnamed Equipment")
                            .font(.headline)
                        
                        Text(equipment.category ?? "Unknown Category")
                            .font(.subheadline)
                        
                        Text(equipment.serialNumber ?? "No Serial Number")
                            .font(.caption)
                        
                        Text(
                            equipment.isAvailable
                            ? "Available"
                            : "On Loan"
                        )
                        .font(.caption)
                    }
                }
            }
            .navigationTitle("Equipment")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        ReturnEquipmentView(
                            repository: CoreDataEquipmentRepository(
                                viewContext: PersistenceController.shared.container.viewContext
                            )
                        )
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddEquipment = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEquipment) {
                AddEquipmentView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.loadEquipment()
                viewModel.importSharedEquipment()
            }
        }
    }
}
