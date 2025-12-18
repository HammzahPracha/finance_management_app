import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../services/database_service.dart';
import 'package:uuid/uuid.dart';

class TransactionController extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final Uuid _uuid = const Uuid();

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCurrency = 'PKR';

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCurrency => _selectedCurrency;

  void setCurrency(String currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  // Get transactions for a user
  Future<void> loadTransactions(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await _databaseService.getAllTransactions(userId);
      _transactions = _transactions
          .where((t) => t.currency == _selectedCurrency)
          .toList();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add transaction
  Future<bool> addTransaction({
    required String title,
    required double amount,
    required TransactionType type,
    required String category,
    required String userId,
    required String currency,
    String? description,
    DateTime? date,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final transaction = TransactionModel(
        id: _uuid.v4(),
        title: title,
        amount: amount,
        type: type,
        category: category,
        date: date ?? DateTime.now(),
        description: description,
        userId: userId,
        currency: currency,
      );

      await _databaseService.saveTransaction(transaction);
      _transactions.insert(0, transaction);
      _transactions.removeWhere(
        (t) => t.currency != _selectedCurrency,
      ); // keep filter
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update transaction
  Future<bool> updateTransaction(TransactionModel transaction) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.updateTransaction(transaction);
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
        _transactions.sort((a, b) => b.date.compareTo(a.date));
      }
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete transaction
  Future<bool> deleteTransaction(String transactionId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.deleteTransaction(transactionId);
      _transactions.removeWhere((t) => t.id == transactionId);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get analytics
  Future<Map<String, double>> getCategoryTotals(
    String userId,
    TransactionType type,
    String currency,
  ) async {
    try {
      return await _databaseService.getCategoryTotals(userId, type, currency);
    } catch (e) {
      return {};
    }
  }

  Future<double> getTotalIncome(String userId) async {
    try {
      return await _databaseService.getTotalIncome(userId, _selectedCurrency);
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> getTotalExpense(String userId) async {
    try {
      return await _databaseService.getTotalExpense(userId, _selectedCurrency);
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> getBalance(String userId) async {
    try {
      return await _databaseService.getBalance(userId, _selectedCurrency);
    } catch (e) {
      return 0.0;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
