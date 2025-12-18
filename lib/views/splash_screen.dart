import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthController>(
        builder: (context, auth, _) {
          if (auth.isLoadingUser) {
            return const Center(child: CircularProgressIndicator());
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (auth.currentUser != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          });

          return const Center(child: Text('Loading...'));
        },
      ),
    );
  }
}
