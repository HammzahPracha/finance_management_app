import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';

class DatabaseService {
  // ---------------- Singleton (fixes late error) ----------------
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  late final Box<UserModel> _usersBox;
  late final Box<TransactionModel> _transactionsBox;

  // ---------------- Initialize Hive Boxes ----------------
  Future<void> init() async {
    // Open users box
    if (!Hive.isBoxOpen('users')) {
      _usersBox = await Hive.openBox<UserModel>('users');
    } else {
      _usersBox = Hive.box<UserModel>('users');
    }

    // Open transactions box
    if (!Hive.isBoxOpen('transactions')) {
      _transactionsBox =
      await Hive.openBox<TransactionModel>('transactions');
    } else {
      _transactionsBox = Hive.box<TransactionModel>('transactions');
    }
  }

  // ---------------- User operations ----------------
  Future<void> saveUser(UserModel user) async {
    await _usersBox.put(user.id, user);
  }

  Future<UserModel?> getUser(String userId) async {
    return _usersBox.get(userId);
  }

  Future<List<UserModel>> getAllUsers() async {
    return _usersBox.values.toList();
  }

  Future<void> deleteUser(String userId) async {
    await _usersBox.delete(userId);
  }

  // ---------------- Transaction operations ----------------
  Future<void> saveTransaction(TransactionModel transaction) async {
    await _transactionsBox.put(transaction.id, transaction);
  }

  Future<TransactionModel?> getTransaction(String transactionId) async {
    return _transactionsBox.get(transactionId);
  }

  Future<List<TransactionModel>> getAllTransactions(String userId) async {
    final list = _transactionsBox.values
        .where((t) => t.userId == userId)
        .toList();

    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _transactionsBox.delete(transactionId);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _transactionsBox.put(transaction.id, transaction);
  }

  // ---------------- Analytics ----------------
  Future<Map<String, double>> getCategoryTotals(
      String userId, TransactionType type, String currency) async {
    final transactions = await getAllTransactions(userId);
    final filtered = transactions
        .where((t) => t.type == type && t.currency == currency);

    final Map<String, double> totals = {};
    for (var t in filtered) {
      final current = totals[t.category] ?? 0.0;
      totals[t.category] = current + t.amount;
    }

    return totals;
  }

  Future<double> getTotalIncome(String userId, String currency) async {
    final transactions = await getAllTransactions(userId);
    final filtered = transactions.where(
            (t) => t.type == TransactionType.income && t.currency == currency);

    double total = 0.0;
    for (var t in filtered) {
      total += t.amount;
    }
    return total;
  }

  Future<double> getTotalExpense(String userId, String currency) async {
    final transactions = await getAllTransactions(userId);
    final filtered = transactions.where(
            (t) => t.type == TransactionType.expense && t.currency == currency);

    double total = 0.0;
    for (var t in filtered) {
      total += t.amount;
    }
    return total;
  }

  Future<double> getBalance(String userId, String currency) async {
    final income = await getTotalIncome(userId, currency);
    final expense = await getTotalExpense(userId, currency);
    return income - expense;
  }
}
