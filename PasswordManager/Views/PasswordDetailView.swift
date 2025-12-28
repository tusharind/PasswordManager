import SwiftUI

struct PasswordDetailView: View {
    @StateObject var viewModel: PasswordDetailViewModel
    @EnvironmentObject private var container: DependencyContainer

    init(item: PasswordItem) {
        let encryptionService = DependencyContainer.shared.encryptionService
        _viewModel = StateObject(
            wrappedValue: PasswordDetailViewModel(
                item: item,
                encryptionService: encryptionService
            )
        )
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    CircleIconHeader(iconName: "key.fill")

                    AccountInfoSection(
                        isEditing: viewModel.isEditing,
                        accountType: viewModel.item.accountType ?? "N/A",
                        username: viewModel.item.username ?? "N/A",
                        editAccountType: $viewModel.editAccountType,
                        editUsername: $viewModel.editUsername
                    )

                    PasswordSection(
                        isEditing: viewModel.isEditing,
                        isRevealed: viewModel.isRevealed,
                        revealedPassword: viewModel.revealedPassword,
                        editPasswordInput: $viewModel.editPasswordInput,
                        onToggleReveal: viewModel.toggleReveal
                    )

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    if viewModel.isEditing {
                        EditModeButtons(
                            onSave: viewModel.saveChanges,
                            onCancel: { viewModel.isEditing = false }
                        )
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle(viewModel.item.accountType ?? "Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !viewModel.isEditing {
                    Button("Edit") {
                        if !viewModel.isRevealed {
                            viewModel.toggleReveal()
                        }
                        viewModel.editPasswordInput = viewModel.revealedPassword
                        viewModel.isEditing = true
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
}
