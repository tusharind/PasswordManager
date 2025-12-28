# Password Manager

A secure, elegant iOS password manager app built with SwiftUI and CoreData. Store and manage your passwords locally with military-grade encryption.

![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## Features

- **Bank-Level Security**: AES-GCM 256-bit encryption using Apple's CryptoKit
- **Secure Key Storage**: Master encryption key stored in iOS Keychain
- **Local Storage**: All data stays on your device using Core Data
- **Modern UI**: Beautiful, minimalist design with gradient accents
- **Password Strength Indicator**: Real-time feedback with 3 strength levels (Weak, Medium, Strong)
- **Full CRUD Operations**: Create, Read, Update, and Delete passwords
- **Reveal Protection**: Passwords hidden by default, reveal on demand
- **Swipe to Delete**: Easy password management
- **Native iOS Experience**: Built entirely with SwiftUI

## Screenshots

### Main Features
- **Empty State**: Welcoming screen with gradient call-to-action
- **Password List**: Card-based design with account icons
- **Add Password**: Clean form with real-time strength indicator
- **Password Details**: Secure reveal and edit capabilities

## Requirements

- **Xcode**: 14.0 or later
- **iOS**: 15.0 or later
- **macOS**: Monterey (12.0) or later for development

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/PasswordManager.git
cd PasswordManager
```

### 2. Open in Xcode

```bash
open PasswordManager.xcodeproj
```

Or simply double-click the `PasswordManager.xcodeproj` file in Finder.

### 3. Select Your Target

1. In Xcode, click on the device/simulator selector in the toolbar
2. Choose either:
   - **iOS Simulator**: Select any iPhone model (iPhone 15 Pro recommended)
   - **Physical Device**: Connect your iPhone via USB and select it

### 4. Build and Run

**Option A: Using Keyboard Shortcut**
- Press `⌘ + R` (Command + R)

**Option B: Using Menu**
- Click `Product` → `Run`

**Option C: Using Button**
- Click the Play button in the top-left corner

### 5. First Launch

On first launch:
1. You'll see an empty state screen
2. Tap "Add Your First Password" to create your first entry
3. Fill in account details and password
4. Watch the real-time strength indicator
5. Tap "Save Password"

## Troubleshooting

### Build Failures

If you encounter build errors:

1. **Clean Build Folder**
   ```
   Product → Clean Build Folder (⌘ + Shift + K)
   ```

2. **Reset Simulator** (if using simulator)
   ```
   Device → Erase All Content and Settings
   ```

3. **Restart Xcode**
   - Quit Xcode completely
   - Reopen the project

### Common Issues

**Issue**: "Developer cannot be verified"
- **Solution**: For physical devices, trust your developer certificate in Settings → General → Device Management

**Issue**: Core Data errors
- **Solution**: Delete the app from simulator/device and reinstall

## Project Structure

```
PasswordManager/
├── App/
│   └── PasswordManagerApp.swift       # App entry point
├── Models/
│   └── PasswordManager.xcdatamodeld/  # Core Data model
├── Views/
│   ├── ContentView.swift              # Main password list
│   ├── AddPasswordView.swift          # Add password form
│   ├── PasswordDetailView.swift       # View/Edit details
│   └── PasswordStrengthIndicator.swift # Strength indicator UI
├── ViewModels/
│   ├── PasswordListViewModel.swift
│   ├── AddPasswordViewModel.swift
│   └── PasswordDetailViewModel.swift
├── Services/
│   ├── EncryptionService.swift        # AES-GCM encryption
│   ├── KeychainService.swift          # Keychain management
│   └── PasswordStrengthCalculator.swift
└── Persistence/
    ├── Persistence.swift              # Core Data stack
    └── PasswordRepository.swift       # Data access layer
```

## Security Architecture

### Encryption
- **Algorithm**: AES-GCM (Galois/Counter Mode)
- **Key Size**: 256 bits
- **Framework**: Apple CryptoKit (native iOS security)

### Key Management
- Symmetric encryption key generated on first launch
- Key stored securely in iOS Keychain
- Never exposed in memory longer than necessary
- Unique key per app installation

### Data Storage
- Passwords stored as encrypted binary data in Core Data
- SQLite database encrypted at OS level (iOS Data Protection)
- All data remains local - no cloud sync

## Design Philosophy

- **Minimalist**: Clean interface without clutter
- **Secure by Default**: Passwords hidden unless explicitly revealed
- **User Feedback**: Real-time password strength analysis
- **Modern iOS**: Gradients, cards, and smooth animations

## Usage Guide

### Adding a Password
1. Tap the **+** button (top-right)
2. Enter account type (e.g., "Gmail", "Facebook")
3. Enter username/email
4. Enter password (watch the strength indicator)
5. Tap "Save Password"

### Viewing a Password
1. Tap any password card from the list
2. Tap the **eye icon** to reveal the password
3. View the password strength indicator

### Editing a Password
1. Open password details
2. Tap "Edit" (top-right)
3. Modify fields as needed
4. Tap "Save Changes"

### Deleting a Password
**Option 1**: Swipe left on any password card → Tap "Delete"

**Option 2**: Tap "Edit" (top-left) → Tap red minus icon → Confirm

## Testing

The app includes encryption verification. To run tests:

1. Open the project in Xcode
2. Press `⌘ + U` or select `Product → Test`
3. View test results in the Test Navigator

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Author

Built with SwiftUI

## Acknowledgments

- Apple CryptoKit for encryption
- SwiftUI for the beautiful UI framework
- Core Data for local persistence

---

**Security Notice**: This app stores all data locally on your device. Back up your device regularly. If you uninstall the app or reset your device, all stored passwords will be permanently lost.
