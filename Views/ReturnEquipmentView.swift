import SwiftUI

struct ReturnEquipmentView: View {
    
    @StateObject private var viewModel: ReturnEquipmentViewModel
    
    init(repository: EquipmentRepository) {
        _viewModel = StateObject(
            wrappedValue: ReturnEquipmentViewModel(
                repository: repository
            )
        )
    }
    
    var body: some View {
        List {
            if viewModel.activeLoans.isEmpty {
                ContentUnavailableView(
                    "No Active Loans",
                    systemImage: "checkmark.circle",
                    description: Text("All equipment has been returned.")
                )
            } else {
                ForEach(viewModel.activeLoans, id: \.objectID) { loan in
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text(
                            loan.equipment?.name
                            ?? "Unknown Equipment"
                        )
                        .font(.headline)
                        
                        Text(
                            loan.equipment?.serialNumber
                            ?? "No Serial Number"
                        )
                        .font(.subheadline)
                        
                        Text("Borrower: \(loan.borrowerName ?? "Unknown")")
                            .font(.subheadline)
                        
                        if let dueDate = loan.dueDate {
                            Text("Due: \(dueDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                        }
                        
                        Button("Return Equipment") {
                            viewModel.returnEquipment(loan)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.vertical, 6)
                }
            }
            
            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Return Equipment")
        .onAppear {
            viewModel.loadActiveLoans()
        }
    }
}
