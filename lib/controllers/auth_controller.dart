import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isLoadingUser = true;
  String? _errorMessage;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoadingUser => _isLoadingUser;
  String? get errorMessage => _errorMessage;

  /// ✅ DO NOT use async code in constructor
  AuthController();

  /// ✅ MUST be called from main.dart
  Future<void> init() async {
    _isLoadingUser = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId != null) {
        _currentUser = await _authService.getUserById(userId);
      } else {
        _currentUser = null;
      }
    } catch (e) {
      _currentUser = null;
      _errorMessage = e.toString();
    }

    _isLoadingUser = false;
    notifyListeners();
  }

  // ------------------ Update Profile ------------------
  Future<bool> updateProfile(UserModel user) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.updateUserProfile(user);
      _currentUser = user;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------ Sign In ------------------
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.localLogin(email, password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', _currentUser!.id!);

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------ Register ------------------
  Future<bool> register(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser =
      await _authService.localRegister(email, password, name);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', _currentUser!.id!);

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------ Change Password ------------------
  Future<bool> changePassword(
      String currentPassword,
      String newPassword,
      ) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await _authService.changePassword(
        _currentUser!.id!,
        currentPassword,
        newPassword,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------ Sign Out ------------------
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await _authService.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');

    _currentUser = null;

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
