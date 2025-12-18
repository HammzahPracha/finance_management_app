import 'package:flutter/material.dart';
import 'transaction_model.dart';

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final TransactionType type;
  final Color color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    required this.color,
  });
}

// Predefined categories
class Categories {
  static List<CategoryModel> incomeCategories = [
    CategoryModel(
      id: 'salary',
      name: 'Salary',
      icon: '💰',
      type: TransactionType.income,
      color: const Color(0xFF10B981),
    ),
    CategoryModel(
      id: 'freelance',
      name: 'Freelance',
      icon: '💼',
      type: TransactionType.income,
      color: const Color(0xFF3B82F6),
    ),
    CategoryModel(
      id: 'investment',
      name: 'Investment',
      icon: '📈',
      type: TransactionType.income,
      color: const Color(0xFF8B5CF6),
    ),
    CategoryModel(
      id: 'gift',
      name: 'Gift',
      icon: '🎁',
      type: TransactionType.income,
      color: const Color(0xFFEC4899),
    ),
    CategoryModel(
      id: 'other_income',
      name: 'Other',
      icon: '💵',
      type: TransactionType.income,
      color: const Color(0xFF6B7280),
    ),
  ];

  static List<CategoryModel> expenseCategories = [
    CategoryModel(
      id: 'food',
      name: 'Food',
      icon: '🍔',
      type: TransactionType.expense,
      color: const Color(0xFFEF4444),
    ),
    CategoryModel(
      id: 'shopping',
      name: 'Shopping',
      icon: '🛍️',
      type: TransactionType.expense,
      color: const Color(0xFFF59E0B),
    ),
    CategoryModel(
      id: 'transport',
      name: 'Transport',
      icon: '🚗',
      type: TransactionType.expense,
      color: const Color(0xFF6366F1),
    ),
    CategoryModel(
      id: 'bills',
      name: 'Bills',
      icon: '📄',
      type: TransactionType.expense,
      color: const Color(0xFF8B5CF6),
    ),
    CategoryModel(
      id: 'bills_electricity',
      name: 'Bills • Electricity',
      icon: '💡',
      type: TransactionType.expense,
      color: const Color(0xFF7C3AED),
    ),
    CategoryModel(
      id: 'bills_gas',
      name: 'Bills • Gas',
      icon: '🔥',
      type: TransactionType.expense,
      color: const Color(0xFFF97316),
    ),
    CategoryModel(
      id: 'bills_internet',
      name: 'Bills • Internet',
      icon: '🌐',
      type: TransactionType.expense,
      color: const Color(0xFF0EA5E9),
    ),
    CategoryModel(
      id: 'bills_water',
      name: 'Bills • Water',
      icon: '💧',
      type: TransactionType.expense,
      color: const Color(0xFF38BDF8),
    ),
    CategoryModel(
      id: 'groceries',
      name: 'Groceries',
      icon: '🛒',
      type: TransactionType.expense,
      color: const Color(0xFF22C55E),
    ),
    CategoryModel(
      id: 'entertainment',
      name: 'Entertainment',
      icon: '🎬',
      type: TransactionType.expense,
      color: const Color(0xFFEC4899),
    ),
    CategoryModel(
      id: 'health',
      name: 'Health',
      icon: '🏥',
      type: TransactionType.expense,
      color: const Color(0xFF10B981),
    ),
    CategoryModel(
      id: 'education',
      name: 'Education',
      icon: '📚',
      type: TransactionType.expense,
      color: const Color(0xFF3B82F6),
    ),
    CategoryModel(
      id: 'other_expense',
      name: 'Other',
      icon: '💸',
      type: TransactionType.expense,
      color: const Color(0xFF6B7280),
    ),
  ];

  static List<CategoryModel> getAllCategories() {
    return [...incomeCategories, ...expenseCategories];
  }

  static CategoryModel? getCategoryById(String id) {
    return getAllCategories().firstWhere(
      (cat) => cat.id == id,
      orElse: () => expenseCategories.last,
    );
  }
}
