# Quick Setup Guide

## Step-by-Step Setup Instructions

### 1. Install Flutter Dependencies

```bash
flutter pub get
```

### 2. Generate Hive Type Adapters

This is **REQUIRED** for the app to work. Run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate the following files:
- `lib/models/user_model.g.dart`
- `lib/models/transaction_model.g.dart`

**Note**: If you see errors, try:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Run the App

```bash
flutter run
```

## First Run

1. The app will show a splash screen
2. Navigate to "Sign Up" to create an account
3. Fill in:
   - Name: Your full name
   - Email: Your email address
   - Password: At least 6 characters
4. After registration, you'll be automatically logged in
5. Start adding transactions!

## Testing the App

### Create Test Transactions

1. Tap the "+" floating action button
2. Select "Income" or "Expense"
3. Fill in:
   - Title: e.g., "Salary" or "Groceries"
   - Amount: e.g., "5000" or "50.99"
   - Category: Select from the list
   - Date: Choose a date
4. Tap "Add Transaction"

### View Analytics

- Go to Dashboard tab
- See your balance, income, and expense totals
- View charts showing your financial trends
- Check category-wise breakdowns

## Common Issues

### "TypeAdapter not found" Error

**Solution**: Run the build_runner command:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### App Crashes on Launch

**Solution**:
1. Delete the app from your device/emulator
2. Run `flutter clean`
3. Run `flutter pub get`
4. Generate adapters again
5. Run `flutter run`

### Charts Not Showing

**Solution**: 
- Make sure you have added some transactions first
- Charts need data to display

## Firebase Setup (Optional)

The app works with local authentication by default. To enable Firebase:

1. Create a Firebase project
2. Add Android/iOS apps
3. Download configuration files
4. Place them in the correct directories
5. The app will automatically use Firebase if configured

## Need Help?

Check the main README.md for detailed documentation.

