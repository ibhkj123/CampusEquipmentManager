import SwiftUI

struct RecordLoanView: View {
    
    let equipment: Equipment
    
    @StateObject private var viewModel: RecordLoanViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var borrowerName = ""
    @State private var dueDate = Calendar.current.date(
        byAdding: .day,
        value: 7,
        to: Date()
    ) ?? Date()
    
    init(
        equipment: Equipment,
        repository: EquipmentRepository
    ) {
        self.equipment = equipment
        
        _viewModel = StateObject(
            wrappedValue: RecordLoanViewModel(repository: repository)
        )
    }
    
    var body: some View {
        Form {
            Section("Equipment") {
                LabeledContent(
                    "Name",
                    value: equipment.name ?? "Unknown"
                )
                
                LabeledContent(
                    "Serial Number",
                    value: equipment.serialNumber ?? "Unknown"
                )
            }
            
            Section("Loan Details") {
                TextField(
                    "Borrower Name",
                    text: $borrowerName
                )
                
                DatePicker(
                    "Due Date",
                    selection: $dueDate,
                    displayedComponents: .date
                )
            }
            
            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
            
            Section {
                Button("Record Loan") {
                    viewModel.recordLoan(
                        equipment: equipment,
                        borrowerName: borrowerName,
                        dueDate: dueDate
                    )
                }
                .disabled(borrowerName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .navigationTitle("Record Loan")
        .onChange(of: viewModel.loanRecorded) { _, recorded in
            if recorded {
                dismiss()
            }
        }
    }
}
