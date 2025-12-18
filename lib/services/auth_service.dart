import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'database_service.dart';

class AuthService {
  final DatabaseService _databaseService = DatabaseService();

  // ------------------ Local Login ------------------
  Future<UserModel?> localLogin(String email, String password) async {
    final users = await _databaseService.getAllUsers();
    final user = users.firstWhere(
          (u) => u.email == email,
      orElse: () => throw Exception('User not found'),
    );

    final prefs = await SharedPreferences.getInstance();
    final savedPassword = prefs.getString('password_${user.id}');

    if (savedPassword == password) {
      await _saveUserSession(user);
      return user;
    } else {
      throw Exception('Invalid password');
    }
  }

  // ------------------ Local Register ------------------
  Future<UserModel?> localRegister(
      String email,
      String password,
      String name,
      ) async {
    final users = await _databaseService.getAllUsers();
    if (users.any((u) => u.email == email)) {
      throw Exception('Email already exists');
    }

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      createdAt: DateTime.now(),
    );

    await _databaseService.saveUser(newUser);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password_${newUser.id}', password);

    await _saveUserSession(newUser);
    return newUser;
  }

  // ------------------ Change Password ------------------
  Future<void> changePassword(
      String userId,
      String currentPassword,
      String newPassword,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPassword = prefs.getString('password_$userId');

    if (savedPassword == null) {
      throw Exception('Password not found');
    }

    if (savedPassword != currentPassword) {
      throw Exception('Current password is incorrect');
    }

    await prefs.setString('password_$userId', newPassword);
  }

  // ------------------ Sign Out ------------------
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_id');
  }

  // ------------------ Save Session ------------------
  Future<void> _saveUserSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user_id', user.id!);
  }

  // ------------------ Update Profile ------------------
  Future<void> updateUserProfile(UserModel user) async {
    await _databaseService.saveUser(user);
  }

  Future<UserModel?> getUserById(String userId) async {}
}
// ------------------ Get Current User ------------------
Future<UserModel?> getCurrentUser() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('current_user_id');

    if (userId != null) {
      var _databaseService;
      return await _databaseService.getUser(userId);
    }
    return null;
  } catch (e) {
    return null;
  }
}
