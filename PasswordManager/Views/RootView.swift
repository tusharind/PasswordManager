import CoreData
import SwiftUI

struct RootView: View {
    @EnvironmentObject private var container: DependencyContainer
    @StateObject private var viewModel: PasswordListViewModel
    @State private var showingAddScreen = false

    init() {
        let container = DependencyContainer.shared
        _viewModel = StateObject(
            wrappedValue: PasswordListViewModel(
                repository: container.passwordRepository
            )
        )
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                if viewModel.passwords.isEmpty {

                    VStack(spacing: 24) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 70))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(
                                color: .blue.opacity(0.3),
                                radius: 10,
                                x: 0,
                                y: 5
                            )

                        VStack(spacing: 8) {
                            Text("No Passwords Saved")
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Securely store your passwords")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }

                        Button(action: { showingAddScreen = true }) {
                            Label(
                                "Add Your First Password",
                                systemImage: "plus.circle.fill"
                            )
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(
                                color: .blue.opacity(0.4),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                } else {

                    List {
                        ForEach(viewModel.passwords) { passwordItem in
                            NavigationLink(
                                destination: PasswordDetailView(
                                    item: passwordItem
                                )
                            ) {
                                PasswordCardView(item: passwordItem)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(
                                EdgeInsets(
                                    top: 6,
                                    leading: 16,
                                    bottom: 6,
                                    trailing: 16
                                )
                            )
                        }
                        .onDelete(perform: viewModel.deletePassword)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Passwords")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddScreen = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
                if !viewModel.passwords.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
            }
            .sheet(
                isPresented: $showingAddScreen,
                onDismiss: {
                    viewModel.fetchPasswords()
                }
            ) {
                AddPasswordView()
                    .environmentObject(container)
            }
        }
    }
}
