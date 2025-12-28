import CoreData
import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = PasswordListViewModel()
    @State private var showingAddScreen = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.passwords, id: \.id) { passwordItem in
                    NavigationLink(
                        destination: PasswordDetailView(item: passwordItem)
                    ) {
                        VStack(alignment: .leading) {
                            Text(passwordItem.accountType ?? "Unknown Account")
                                .font(.headline)
                            Text(passwordItem.username ?? "Unknown User")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: viewModel.deletePassword)
            }
            .navigationTitle("Passwords")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddScreen = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddPasswordView()
            }
            .onAppear {
                viewModel.fetchPasswords()
            }
        }
    }
}
