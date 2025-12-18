import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode =>
      _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  // ✅ LIGHT THEME (clean)
  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),

    primaryColor: const Color(0xFF00BFA5),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.black,
    ),

    cardColor: Colors.white,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black54),
    ),
  );

  // ✅ DARK THEME (finance-friendly)
  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    // Softer dark background
    scaffoldBackgroundColor: const Color(0xFF181818),

    // Softer primary color
    primaryColor: const Color(0xFF00C897),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F), // slightly lighter
      elevation: 0,
      foregroundColor: Colors.white70, // softer white
    ),

    // Cards should slightly pop from background
    cardColor: const Color(0xFF242424),

    // Text colors softer for readability
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white70),
      bodyMedium: TextStyle(color: Colors.white60),
      bodySmall: TextStyle(color: Colors.white54),
    ),

    // Optional: subtle button & icon theme
    iconTheme: const IconThemeData(color: Colors.white70),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF00C897),
        foregroundColor: Colors.white,
      ),
    ),
  );


  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}
