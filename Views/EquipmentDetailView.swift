import SwiftUI
import CoreData

struct EquipmentDetailView: View {
    
    let equipment: Equipment
    
    @State private var showingRecordLoan = false
    
    var body: some View {
        Form {
            Section("Equipment Information") {
                LabeledContent(
                    "Name",
                    value: equipment.name ?? "Unknown"
                )
                
                LabeledContent(
                    "Category",
                    value: equipment.category ?? "Unknown"
                )
                
                LabeledContent(
                    "Serial Number",
                    value: equipment.serialNumber ?? "Unknown"
                )
                
                LabeledContent(
                    "Status",
                    value: equipment.isAvailable
                    ? "Available"
                    : "On Loan"
                )
            }
            
            Section {
                if equipment.isAvailable {
                    Text("This equipment is available to borrow.")
                        .foregroundStyle(.green)
                    
                    Button("Record Loan") {
                        showingRecordLoan = true
                    }
                } else {
                    Text("This equipment is currently on loan.")
                        .foregroundStyle(.orange)
                }
            }
        }
        .navigationTitle(equipment.name ?? "Equipment")
        .sheet(isPresented: $showingRecordLoan) {
            RecordLoanView(
                equipment: equipment,
                repository: CoreDataEquipmentRepository(
                    viewContext: PersistenceController.shared.container.viewContext
                )
            )
        }
    }
}
