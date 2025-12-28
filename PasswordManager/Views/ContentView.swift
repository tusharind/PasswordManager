import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: PasswordItem.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \PasswordItem.createdAt, ascending: false)
        ],
        animation: .default
    )
    private var passwords: FetchedResults<PasswordItem>

    @State private var showingAddScreen = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                if passwords.isEmpty {

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
                        ForEach(passwords) { passwordItem in
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
                        .onDelete(perform: deletePasswords)
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
                if !passwords.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddPasswordView()
                    .environmentObject(DependencyContainer.shared)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    private func deletePasswords(offsets: IndexSet) {
        withAnimation {
            offsets.map { passwords[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print(
                    "Error deleting password: \(nsError), \(nsError.userInfo)"
                )
            }
        }
    }
}

struct PasswordCardView: View {
    let item: PasswordItem

    var body: some View {
        HStack(spacing: 16) {

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.2), .purple.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)

                Image(systemName: "key.fill")
                    .font(.title3)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.accountType ?? "Unknown Account")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(item.username ?? "Unknown User")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
