# Finance Management App

A modern, feature-rich Finance Management application built with Flutter. This app helps you track your income and expenses, visualize your financial data with charts, and manage your transactions efficiently.

## Features

- 🔐 **Authentication**: Secure login and registration (Firebase Auth or Local Auth)
- 💰 **Transaction Management**: Add, edit, and delete income/expense transactions
- 📊 **Analytics Dashboard**: Visualize your financial data with interactive charts
- 📈 **Charts & Graphs**: 
  - Line charts for income/expense trends
  - Pie charts for category-wise breakdown
- 🎨 **Modern UI**: Beautiful, responsive design with Material Design 3
- 💾 **Local Storage**: Data persistence using Hive database
- 📱 **Multi-device Support**: Login from multiple devices
- 🏷️ **Categories**: Predefined categories for income and expenses
- 👤 **User Profile**: Manage your profile and view statistics

## Screens

1. **Splash Screen**: Animated welcome screen
2. **Login Screen**: User authentication
3. **Register Screen**: New user registration
4. **Home/Dashboard Screen**: Main screen with balance card, charts, and recent transactions
5. **Profile Screen**: User profile with statistics and all transactions
6. **Settings Screen**: App settings and account management
7. **Add Transaction Screen**: Form to add new income/expense transactions

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_model.dart
│   ├── transaction_model.dart
│   └── category_model.dart
├── views/                    # UI screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── dashboard_screen.dart
│   ├── profile_screen.dart
│   ├── settings_screen.dart
│   └── add_transaction_screen.dart
├── controllers/              # State management
│   ├── auth_controller.dart
│   └── transaction_controller.dart
├── services/                 # Business logic
│   ├── auth_service.dart
│   └── database_service.dart
└── widgets/                  # Reusable widgets
    ├── custom_button.dart
    ├── custom_text_field.dart
    ├── transaction_card.dart
    ├── balance_card.dart
    ├── category_chart.dart
    └── line_chart_widget.dart
```

## Prerequisites

Before running this project, make sure you have:

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android Emulator or iOS Simulator / Physical device

## Installation & Setup

### 1. Clone or Download the Project

```bash
cd finance_management_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Hive Adapters

The project uses Hive for local storage. You need to generate the type adapters:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. (Optional) Firebase Setup

If you want to use Firebase Authentication:

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add your Android/iOS app to the project
3. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
4. Place them in:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
5. Follow Firebase setup instructions for Flutter

**Note**: The app works with local authentication by default, so Firebase setup is optional.

### 5. Create Assets Folder (Optional)

If you want to add custom images/icons:

```bash
mkdir -p assets/images
mkdir -p assets/icons
```

Update `pubspec.yaml` if you add assets.

## Running the App

### Run on Android/iOS Emulator

```bash
flutter run
```

### Run on Specific Device

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

### Build APK (Android)

```bash
flutter build apk --release
```

### Build IPA (iOS)

```bash
flutter build ios --release
```

## Usage

### First Time Setup

1. Launch the app
2. You'll see the splash screen
3. Navigate to the Register screen
4. Create a new account with:
   - Full Name
   - Email
   - Password (minimum 6 characters)
5. After registration, you'll be logged in automatically

### Adding Transactions

1. Tap the floating action button (FAB) with "+" icon
2. Select transaction type (Income or Expense)
3. Fill in the details:
   - Title
   - Amount
   - Category
   - Date
   - Description (optional)
4. Tap "Add Transaction"

### Viewing Analytics

1. Navigate to the Dashboard tab
2. View your:
   - Total Balance
   - Total Income
   - Total Expense
   - Income/Expense trend chart
   - Category-wise breakdown (pie charts)

### Managing Profile

1. Go to the Profile tab
2. View your statistics
3. See all your transactions
4. Access Settings from the top-right icon

## Dependencies

- **provider**: State management
- **hive** & **hive_flutter**: Local database
- **firebase_core** & **firebase_auth**: Authentication (optional)
- **fl_chart**: Beautiful charts
- **google_fonts**: Custom typography
- **intl**: Date formatting
- **shared_preferences**: User preferences
- **uuid**: Unique ID generation

## Troubleshooting

### Issue: Hive adapter generation fails

**Solution**: Run the build_runner command again:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Firebase not working

**Solution**: 
- Make sure you've completed Firebase setup
- Check that `google-services.json` is in the correct location
- Verify Firebase dependencies in `pubspec.yaml`

### Issue: App crashes on launch

**Solution**:
- Run `flutter clean`
- Delete `pubspec.lock`
- Run `flutter pub get`
- Regenerate Hive adapters

## Customization

### Colors

Edit the theme in `lib/main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF6366F1), // Change this color
  brightness: Brightness.light,
),
```

### Categories

Edit categories in `lib/models/category_model.dart`:
- Add/remove income categories
- Add/remove expense categories
- Customize icons and colors

### Fonts

The app uses Google Fonts (Inter). To change:
1. Update `pubspec.yaml` with a different Google Font
2. Or use system fonts by removing `google_fonts` dependency

## Future Enhancements

- [ ] Export transactions to CSV/PDF
- [ ] Budget planning and alerts
- [ ] Recurring transactions
- [ ] Multiple currency support
- [ ] Dark mode
- [ ] Cloud sync
- [ ] Receipt scanning
- [ ] Financial goals tracking

## License

This project is open source and available for personal and commercial use.

## Support

For issues, questions, or contributions, please open an issue on the project repository.

---

**Built with ❤️ using Flutter**

