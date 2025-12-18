import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  TransactionType type;

  @HiveField(4)
  String category;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  String? description;

  @HiveField(7)
  String userId;

  @HiveField(8)
  String currency;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.description,
    required this.userId,
    this.currency = 'PKR',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.toString().split('.').last,
      'category': category,
      'date': date.toIso8601String(),
      'description': description,
      'userId': userId,
      'currency': currency,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      category: json['category'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      userId: json['userId'],
      currency: json['currency'] ?? 'PKR',
    );
  }
}

@HiveType(typeId: 2)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}
