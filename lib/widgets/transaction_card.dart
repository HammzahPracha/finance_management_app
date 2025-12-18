import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final category = Categories.getCategoryById(transaction.category);
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome
        ? const Color(0xFF10B981)
        : const Color(0xFFEF4444);
    final currencyPrefix = transaction.currency.toUpperCase();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (category?.color ?? Colors.grey).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    category?.icon ?? '💰',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category?.name ?? transaction.category,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isIncome ? '+' : '-'}$currencyPrefix ${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: amountColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, yyyy').format(transaction.date),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
              if (onDelete != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: Colors.grey.shade400,
                  onPressed: onDelete,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
