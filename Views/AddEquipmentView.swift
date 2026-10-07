import SwiftUI

struct AddEquipmentView: View {
    
    @ObservedObject var viewModel: EquipmentListViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var category = ""
    @State private var serialNumber = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Equipment Details") {
                    TextField("Name", text: $name)
                    
                    TextField("Category", text: $category)
                    
                    TextField("Serial Number", text: $serialNumber)
                }
                
                Section {
                    Button("Add Equipment") {
                        viewModel.addEquipment(
                            name: name,
                            category: category,
                            serialNumber: serialNumber
                        )
                        
                        dismiss()
                    }
                    .disabled(
                        name.isEmpty ||
                        category.isEmpty ||
                        serialNumber.isEmpty
                    )
                }
            }
            .navigationTitle("Add Equipment")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
