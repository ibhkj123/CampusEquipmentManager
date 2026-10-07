import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    private let repository: EquipmentRepository

    init(repository: EquipmentRepository) {
        self.repository = repository

        _viewModel = StateObject(
            wrappedValue: DashboardViewModel(
                repository: repository
            )
        )
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Equipment Summary") {
                    HStack {
                        DashboardCountView(
                            title: "Available",
                            count: viewModel.availableCount
                        )

                        DashboardCountView(
                            title: "On Loan",
                            count: viewModel.onLoanCount
                        )
                    }

                    HStack {
                        DashboardCountView(
                            title: "Overdue",
                            count: viewModel.overdueCount
                        )

                        DashboardCountView(
                            title: "Due Today",
                            count: viewModel.dueTodayCount
                        )
                    }
                }

                Section("Current Loans") {
                    if viewModel.activeLoans.isEmpty {
                        Text("No equipment is currently on loan.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(
                            viewModel.activeLoans,
                            id: \.objectID
                        ) { loan in
                            VStack(
                                alignment: .leading,
                                spacing: 5
                            ) {
                                Text("Equipment on loan")
                                    .font(.headline)

                                Text(
                                    "Borrower: " +
                                    (loan.borrowerName ?? "Unknown")
                                )

                                if let dueDate = loan.dueDate {
                                    Text(
                                        "Due: " +
                                        dueDate.formatted(
                                            date: .abbreviated,
                                            time: .omitted
                                        )
                                    )
                                    .font(.caption)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Campus Equipment")
            .toolbar {
                ToolbarItem(
                    placement: .topBarTrailing
                ) {
                    NavigationLink {
                        EquipmentListView(
                            repository: repository
                        )
                    } label: {
                        Image(systemName: "shippingbox")
                    }
                }
            }
            .onAppear {
                viewModel.loadDashboard()
            }
        }
    }
}

struct DashboardCountView: View {
    let title: String
    let count: Int

    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2)
                .bold()

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}
