import 'package:finance_management_app/views/home_screen.dart';
import 'package:finance_management_app/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'controllers/auth_controller.dart';
import 'controllers/transaction_controller.dart'; // ✅ Add this line
import 'controllers/theme_controller.dart';


import 'services/database_service.dart';

// Your screens
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

// Your Hive model adapters
import 'models/user_model.dart';
import 'models/transaction_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TransactionModelAdapter());

  // Initialize Database (IMPORTANT)
  await DatabaseService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController()..init(),
        ),
        ChangeNotifierProvider(create: (_) => TransactionController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Management App',

      // ✅ USE CONTROLLER THEMES
      theme: themeController.lightTheme,
      darkTheme: themeController.darkTheme,
      themeMode: themeController.themeMode,

      home: Consumer<AuthController>(
        builder: (context, auth, _) {
          if (auth.isLoadingUser) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return auth.currentUser == null
              ? const LoginScreen()
              : const HomeScreen();
        },
      ),
    );
  }
}
