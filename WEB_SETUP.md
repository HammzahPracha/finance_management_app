# Web/Chrome Setup Guide

## ✅ Fixed Issues

### 1. Profile Screen
- ✅ Added currency selector (PKR/USD) to match dashboard functionality
- ✅ Fixed hardcoded PKR currency symbol
- ✅ Added proper state management with `mounted` checks

### 2. Database Service
- ✅ Removed unused import warning
- ✅ Fixed type inference issues in fold operations

### 3. Web Support
- ✅ Created web directory with `index.html` and `manifest.json`
- ✅ Updated `main.dart` for web compatibility
- ✅ Hive initialization works on web (uses IndexedDB)

## 🚀 Running on Chrome

### Step 1: Generate Hive Adapters (REQUIRED)

Before running, you must generate the Hive type adapters:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `lib/models/currency.g.dart`
- `lib/models/user_model.g.dart`
- `lib/models/transaction_type.g.dart`
- `lib/models/transaction_model.g.dart`

### Step 2: Run on Chrome

```bash
flutter run -d chrome
```

Or to run in release mode:

```bash
flutter run -d chrome --release
```

### Step 3: Build for Web Deployment

To build for production:

```bash
flutter build web
```

The output will be in the `build/web` directory.

## 🌐 Web-Specific Features

- **Hive Storage**: Uses IndexedDB on web (automatic)
- **Responsive Design**: Works on desktop and mobile browsers
- **PWA Support**: Includes manifest.json for Progressive Web App capabilities

## 📝 Notes

- The app uses Hive for local storage, which works seamlessly on web via IndexedDB
- All features work the same on web as on mobile
- No additional configuration needed for web platform

## 🔧 Troubleshooting

### If you see adapter errors:
Run the build_runner command again:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### If Chrome doesn't appear in devices:
```bash
flutter devices
```
Make sure Chrome is installed and available in your PATH.

### If web build fails:
```bash
flutter clean
flutter pub get
flutter build web
```

