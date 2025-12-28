import SwiftUI

struct AccountInfoSection: View {
    let isEditing: Bool
    let accountType: String
    let username: String
    @Binding var editAccountType: String
    @Binding var editUsername: String

    var body: some View {
        VStack(spacing: 16) {
            if isEditing {
                CustomTextField(
                    icon: "building.2",
                    placeholder: "Account Type",
                    text: $editAccountType
                )
                CustomTextField(
                    icon: "person",
                    placeholder: "Username",
                    text: $editUsername
                )
                .textInputAutocapitalization(.never)
            } else {
                InfoRow(
                    label: "Account",
                    value: accountType
                )
                InfoRow(
                    label: "Username",
                    value: username
                )
            }
        }
    }
}
